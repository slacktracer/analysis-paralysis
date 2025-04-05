let x = [0.9697, 0.5924, 0.015];
let y = [0.2808, 0.3054, 0.777];

let z = x.map((item, index) => item * y[index]);

console.log(z);

x = [0.34, 0.45, 0.56];
y = [0.808, 0.3054, 0.777];

z = x.map((item, index) => item + y[index]);

console.log(z);
