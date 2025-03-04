import { step } from "./step.js";
import {
  OrthographicCamera,
  Scene,
  ShaderMaterial,
  WebGLRenderer,
} from "three";

export const loop = ({
  camera,
  material,
  renderer,
  scene,
  timer,
}: {
  readonly camera: OrthographicCamera;
  readonly material: ShaderMaterial;
  readonly renderer: WebGLRenderer;
  readonly timer: { previousTime: number; totalTime: number };
  readonly scene: Scene;
}) => {
  requestAnimationFrame((time) => {
    if (timer.previousTime === 0) {
      timer.previousTime = time;
    }

    step({ material, timeElapsed: time - timer.previousTime, timer });

    renderer.render(scene, camera);

    loop({ camera, material, renderer, timer, scene });

    timer.previousTime = time;
  });
};
