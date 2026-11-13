/* Plain JavaScript: no network, packages or build step. Also usable by Node tests. */
(function () {
  'use strict';
  const logistic = (r, x) => r * x * (1 - x);

  function validate({r, x0, transient, count}) {
    if (!Number.isFinite(r) || r < 0 || r > 4) throw Error('Choose r between 0 and 4.');
    if (!Number.isFinite(x0) || x0 < 0 || x0 > 1) throw Error('Choose x₀ between 0 and 1.');
    if (!Number.isInteger(transient) || transient < 0 || transient > 5000) throw Error('Transient must be a whole number from 0 to 5000.');
    if (!Number.isInteger(count) || count < 2 || count > 500) throw Error('Plot between 2 and 500 iterations (a whole number).');
  }

  // The first point is x_transient, so transient=0 includes the initial value.
  function orbit(options) {
    validate(options);
    const {r, x0, transient, count} = options;
    let x = x0;
    for (let i = 0; i < transient; i++) x = logistic(r, x);
    const values = [];
    for (let i = 0; i < count; i++) {
      values.push(x);
      x = logistic(r, x);
    }
    return values;
  }

  function bifurcation(options, slices = 801) {
    validate(options);
    if (!Number.isInteger(slices) || slices < 2 || slices > 2001) throw Error('Invalid slice count.');
    return Array.from({length: slices}, (_, i) => {
      const r = 4 * i / (slices - 1);
      return {r, values: orbit({...options, r, count: Math.min(options.count, 120)})};
    });
  }
  if (typeof module !== 'undefined') module.exports = {logistic, validate, orbit, bifurcation};
  if (typeof document === 'undefined') return;

  const $ = id => document.getElementById(id);
  const form = $('controls');
  const orbitCanvas = $('orbit');
  const bifCanvas = $('bifurcation');
  let diagramKey = '';
  let diagramImage;
  let pending;

  function axes(canvas, xmax, xlabel) {
    const ctx = canvas.getContext('2d');
    const box = {left: 57, top: 12, right: canvas.width - 20, bottom: canvas.height - 43};
    const x = v => box.left + v / xmax * (box.right - box.left);
    const y = v => box.bottom - v * (box.bottom - box.top);
    ctx.fillStyle = '#101a29';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.font = '15px system-ui';
    ctx.lineWidth = 1;
    for (const v of [0, 0.25, 0.5, 0.75, 1]) {
      ctx.strokeStyle = '#34455d';
      ctx.beginPath(); ctx.moveTo(box.left, y(v)); ctx.lineTo(box.right, y(v)); ctx.stroke();
      ctx.fillStyle = '#b9c9dd'; ctx.fillText(String(v), 10, y(v) + 5);
    }
    for (let i = 0; i <= 4; i++) {
      const v = xmax * i / 4;
      ctx.fillText(String(Math.round(v * 100) / 100), x(v) - 6, box.bottom + 23);
    }
    ctx.fillText('x', 20, 15);
    ctx.fillText(xlabel, canvas.width / 2 - 40, canvas.height - 3);
    return {ctx, x, y, box};
  }

  function draw(options) {
    const started = performance.now();
    const values = orbit(options);
    const {ctx, x, y} = axes(orbitCanvas, options.count - 1, 'steps after transient');
    ctx.strokeStyle = '#73edc3'; ctx.lineWidth = 1.3; ctx.beginPath();
    values.forEach((v, i) => i ? ctx.lineTo(x(i), y(v)) : ctx.moveTo(x(i), y(v)));
    ctx.stroke();
    ctx.fillStyle = '#73edc3';
    values.forEach((v, i) => {ctx.beginPath();ctx.arc(x(i), y(v), 2.5, 0, Math.PI * 2);ctx.fill();});
    $('orbit-caption').textContent = `r = ${options.r}; x₀ = ${options.x0}. Showing x${options.transient} through x${options.transient + options.count - 1}. First values: ${values.slice(0, 6).map(v => v.toFixed(6)).join(', ')}. Range: ${Math.min(...values).toFixed(6)}–${Math.max(...values).toFixed(6)}.`;

    // Changing only r reuses the diagram. The marker is drawn after the cache.
    const key = [options.x0, options.transient, options.count].join(':');
    const b = axes(bifCanvas, 4, 'parameter r');
    if (key !== diagramKey) {
      b.ctx.fillStyle = '#73edc3'; b.ctx.globalAlpha = 0.25;
      for (const slice of bifurcation(options)) {
        for (const v of slice.values) b.ctx.fillRect(b.x(slice.r), b.y(v), 1.4, 1.4);
      }
      b.ctx.globalAlpha = 1;
      diagramImage = b.ctx.getImageData(0, 0, bifCanvas.width, bifCanvas.height);
      diagramKey = key;
    } else b.ctx.putImageData(diagramImage, 0, 0);
    b.ctx.strokeStyle = '#ffbc7a'; b.ctx.lineWidth = 2;
    b.ctx.beginPath(); b.ctx.moveTo(b.x(options.r), b.box.top); b.ctx.lineTo(b.x(options.r), b.box.bottom); b.ctx.stroke();
    $('bifurcation').setAttribute('aria-label', `Numerical bifurcation diagram for x₀=${options.x0}, skipping ${options.transient} iterations. Selected r=${options.r}. For typical initial values, a single branch splits into two and then four; this is not a proof of stability or chaos.`);
    $('status').textContent = `Plots updated in ${Math.round(performance.now() - started)} ms. r = ${options.r}.`;
    document.querySelectorAll('[data-r]').forEach(button => button.setAttribute('aria-pressed', String(Number(button.dataset.r) === options.r)));
  }

  function update() {
    cancelAnimationFrame(pending);
    pending = requestAnimationFrame(() => {
      try {
        const options = Object.fromEntries(['r', 'x0', 'transient', 'count'].map(id => [id, $(id).valueAsNumber]));
        validate(options);
        $('error').textContent = '';
        $('r-slider').value = options.r;
        draw(options);
      } catch (error) {
        $('error').textContent = error.message;
        $('status').textContent = 'Plots unchanged. Correct the input to update.';
      }
    });
  }
  form.addEventListener('submit', event => {event.preventDefault(); update();});
  form.addEventListener('input', update);
  $('r-slider').addEventListener('input', () => {$('r').value = $('r-slider').value; update();});
  document.querySelectorAll('[data-r]').forEach(button => button.addEventListener('click', () => {$('r').value = button.dataset.r; update();}));
  update();
}());
