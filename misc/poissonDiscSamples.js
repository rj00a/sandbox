// See p5js.org

const width = 400;
const height = 400;
const r = 10;
const k = 30;
const cellSize = r / Math.sqrt(2);
const samples = [];
const cells = [];
const numCellsWidth = Math.ceil(width / cellSize);
const numCellsHeight = Math.ceil(height / cellSize);
const activeSamples = [];
let invalidState = false;

function toCellCoords(x, y) {
  if (x >= 0 && x < width && y >= 0 && y < height) {
    return {
      x: floor(x / cellSize),
      y: floor(y / cellSize)
    };
  } else {
    return null;
  }
}

function setup() {
  createCanvas(width, height);
  frameRate(120);
  strokeWeight(1);
  for (let i = 0; i < numCellsWidth * numCellsHeight; i++) {
    cells[i] = -1;
  }
  //activeSamples.push(setSampleInCell(random() * width, random() * height));
  const x = random() * width;
  const y = random() * height;
  samples.push({x, y});
  const {x: cellX, y: cellY} = toCellCoords(x, y);
  cells[cellX + cellY * numCellsWidth] = 0;
  activeSamples.push(0);
}

function rotate2d(anchorX, anchorY, x, y, rads) {
  const c = cos(rads);
  const s = sin(rads);
  const x1 = x - anchorX;
  const y1 = y - anchorY;
  return {
    x: x1 * c - y1 * s + anchorX,
    y: x1 * s + y1 * c + anchorY
  };
}

function draw() {
  background(200);
  if (!invalidState) {
    if (activeSamples.length > 0) {
      const activeSampleIdx = floor(random(activeSamples.length));
      const {x: activeX, y: activeY} = samples[activeSamples[activeSampleIdx]];
      let foundValidSample = false;
      loop: for (let i = 0; i < k; i++) {
        const d = random() * r + r;
        const theta = random() * TAU;
        const {x, y} = rotate2d(activeX, activeY, activeX, activeY + d, theta);

        const s = toCellCoords(x, y)
        if (s == null) {
          continue;
        }
        const {x: cellX, y: cellY} = s;

        loop2: for (let cx = cellX - 2; cx <= cellX + 2; cx++) {
          if (cx < 0 || cx >= numCellsWidth) {
            continue;
          }
          for (let cy = cellY - 2; cy <= cellY + 2; cy++) {
            if (cy < 0 || cy >= numCellsHeight) {
              continue;
            }
            const i = cells[cx + cy * numCellsWidth];
            if (i == -1) {
              continue;
            }
            const s = samples[i];
            const d = Math.hypot(s.x - x, s.y - y);
            if (d < r) {
              continue loop;
            }
          }
        }

        foundValidSample = true;
        samples.push({x, y});
        cells[cellX + cellY * numCellsWidth] = samples.length - 1;
        activeSamples.push(samples.length - 1);
        break;
      }
      if (!foundValidSample) {
        //activeSamples.splice(activeSampleIdx, 1)
        if (activeSampleIdx == activeSamples.length - 1) {
          activeSamples.pop();
        } else {
          activeSamples[activeSampleIdx] = activeSamples.pop();
        }
      }
    }

    // Check that the function meets its specification.
    for (let i = 0; i < samples.length; i++) {
      for (let j = i + 1; j < samples.length; j++) {
        const {x: ix, y: iy} = samples[i];
        const {x: jx, y: jy} = samples[j];
        const d = Math.hypot(ix - jx, iy - jy);
        if (d < r) {
          console.log("!!! Invalid distance between:");
          console.log(ix + " " + iy);
          console.log(jx + " " + jy);
          invalidState = true;
        }
      }
    }
  }

  fill(0, 255, 0);
  for (const {x, y} of samples) {
    circle(x, y, 5);
  }

  fill(255, 0, 0);
  for (const i of activeSamples) {
    const {x, y} = samples[i];
    circle(x, y, 5);
  }

  // Draw cell grid lines.
  // for (let x = 0; x < width; x += cellSize) {
  //   line(x, 0, x, height);
  // }

  // for (let y = 0; y < height; y += cellSize) {
  //   line(0, y, width, y)
  // }
}
