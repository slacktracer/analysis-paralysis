/* eslint-disable */

let x = [0.9697, 0.5924, 0.015];
let y = [0.2808, 0.3054, 0.777];

let z = x.map((item, index) => item * y[index]);

console.log(z);

x = [0.34, 0.45, 0.56];
y = [0.808, 0.3054, 0.777];

z = x.map((item, index) => item + y[index]);

console.log(z);

function smoothstep(edge0, edge1, x) {
  if (!x && !edge0 && !edge1) {
    return 0;
  }
  if (x.length) {
    if (edge0.length) {
      return x.map(function (x, i) {
        return smoothstep(edge0[i], edge1[i], x);
      });
    }
    return x.map(function (x, i) {
      return smoothstep(edge0, edge1, x);
    });
  }
  var t = Math.min(Math.max((x - edge0) / (edge1 - edge0), 0.0), 1.0);
  return t * t * (3.0 - 2.0 * t);
}
var v_uv = [0, 0];
var resolution = [0, 0];
var time = 0;
function plot(st, pct) {
  st = st.slice();
  // return step(pct, st[1]) - step(pct, st[1]);
  return smoothstep(pct - 0.1, pct, st[1]) - smoothstep(pct, pct + 0.1, st[1]);
}

function step(edge, x) {
  if (!x && !edge) {
    return 0;
  }
  if (x.length) {
    if (edge.length) {
      return x.map(function (x, i) {
        return step(edge[i], x);
      });
    }
    return x.map(function (x, i) {
      return step(edge, x);
    });
  }

  return x < edge ? 0.0 : 1.0;
}
function main() {
  var st = [gl_FragCoord[0] / resolution[0], gl_FragCoord[1] / resolution[1]];
  var y = st[0];
  var color = [1, 1, 1];
  var pct = plot(st, y);
  color = [
    (1.0 - pct) * color[0],
    (1.0 - pct) * color[1] + pct,
    (1.0 - pct) * color[2],
  ];
  gl_FragColor = [color[0], color[1], color[2], 1];
}

for (var j = 0; j < 20; j++) {
  for (var i = 0; i < 32; i += 1) {
    var p = i / 32;
    var q = j / 20;
    // console.log(p, q, plot([p, q], p))
  }
}

// console.log(1/32)
// console.log(plot([.5, .5], 0.1))
