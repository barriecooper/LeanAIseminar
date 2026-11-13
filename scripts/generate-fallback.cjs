// Regenerate with Node's standard library; participants need no build step.
const {writeFileSync} = require('node:fs');
const {join} = require('node:path');
const {bifurcation} = require('../visualisation/explorer.js');
const options = {r: 3.5, x0: 0.2, transient: 500, count: 80};
const slices = bifurcation(options);
const path = slices.flatMap(({r, values}) => values.map(x =>
  `M${(65 + r / 4 * 900).toFixed(1)},${(445 - x * 360).toFixed(1)}h1`)).join('');
const grid = [0, .25, .5, .75, 1].map(x => `<path d="M65,${445-x*360}H965" stroke="#34455d"/><text x="12" y="${450-x*360}">${x}</text>`).join('');
const ticks = [0, 1, 2, 3, 4].map(r => `<text x="${60+r/4*900}" y="475">${r}</text>`).join('');
writeFileSync(join(__dirname, '../visualisation/fallback.svg'), `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 555" role="img" aria-labelledby="title desc">
<title id="title">Numerical logistic-map bifurcation diagram</title>
<desc id="desc">Fixed settings: x0=0.2, 500 transient iterations, 80 tail points at 801 parameter values from 0 to 4. For this initial value a single branch splits into two and four, with irregular bands and periodic windows later. Floating-point illustration, not a proof of stability or chaos.</desc>
<rect width="1000" height="555" fill="#101a29"/>
<g fill="#eef4fc" font-family="system-ui,sans-serif" font-size="17"><text x="30" y="35" font-size="25">One rule. A world of behaviour.</text><text x="30" y="62">xₙ₊₁ = r xₙ (1 − xₙ) · static numerical fallback</text>${grid}${ticks}<text x="495" y="501">parameter r</text><text x="30" y="95">x</text><text x="30" y="530">x₀ = 0.2 · skip 500 · plot 80 · floating-point observations, not proof</text></g>
<path d="${path}" stroke="#73edc3" stroke-opacity=".28" stroke-width="1.2"/>
</svg>\n`);
