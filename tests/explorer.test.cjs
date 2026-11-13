const {test} = require('node:test');
const assert = require('node:assert/strict');
const {logistic, orbit, bifurcation} = require('../visualisation/explorer.js');
const base = {r: 3.5, x0: 0.2, transient: 500, count: 80};

test('transient=0 starts at x0; skipping shifts the same orbit', () => {
  const all = orbit({...base, transient: 0, count: 10});
  assert.equal(all[0], base.x0);
  assert.equal(all[1], logistic(base.r, base.x0));
  assert.deepEqual(orbit({...base, transient: 4, count: 6}), all.slice(4));
});
test('exact rational two-cycle has a matching floating-point illustration', () => {
  const values = orbit({...base, x0: 3/7, transient: 0, count: 10});
  values.forEach((x, i) => assert.ok(Math.abs(x - (i % 2 ? 6/7 : 3/7)) < 1e-12));
});
test('r=2.5 approaches its known nonzero fixed point; r=3.2 approaches a two-cycle', () => {
  orbit({...base, r: 2.5}).forEach(x => assert.ok(Math.abs(x - 0.6) < 1e-12));
  const values = orbit({...base, r: 3.2});
  assert.ok(Math.abs(values[0] - values[1]) > 0.1);
  values.slice(2).forEach((x,i) => assert.ok(Math.abs(x - values[i]) < 1e-12));
});
test('boundary parameters and seeds stay finite in [0,1]', () => {
  for (const r of [0, 1, 2.5, 3, 3.2, 3.5, 3.9, 4]) {
    for (const x0 of [0, 1, .2, .5, 1e-10, 1 - 1e-10]) {
      orbit({...base, r, x0, transient: 5000, count: 500}).forEach(x =>
        assert.ok(Number.isFinite(x) && x >= 0 && x <= 1));
    }
  }
  assert.deepEqual(orbit({...base, r: 4, x0: 0}), Array(80).fill(0));
});
test('reject invalid and unbounded work, including blank input represented by NaN', () => {
  for (const bad of [{r: NaN}, {r: Infinity}, {r: -1}, {r: 4.01}, {x0: -0.1},
    {x0: 1.1}, {transient: -1}, {transient: 5001}, {transient: .5}, {count: 1}, {count: 501}, {count: NaN}]) {
    assert.throws(() => orbit({...base, ...bad}));
  }
});
test('bifurcation uses the requested seed/transient and covers both parameter endpoints', () => {
  const data = bifurcation({...base, count: 500}, 21);
  assert.equal(data[0].r, 0); assert.equal(data.at(-1).r, 4);
  assert.equal(data[0].values.length, 120);
  data.forEach(slice => assert.deepEqual(slice.values, orbit({...base, r: slice.r, count: 120})));
  assert.throws(() => bifurcation(base, 1));
});
