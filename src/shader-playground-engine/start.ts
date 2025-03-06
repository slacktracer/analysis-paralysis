import { boot } from "./boot.js";
import { loop } from "./loop.js";
import { makeWindowResizeHandler } from "./make-window-resize-handler.js";

export const start = async ({
  fragmentShader,
  vertexShader,
  window,
}: {
  fragmentShader: string;
  vertexShader: string;
  window: Window;
}) => {
  const { camera, material, renderer, scene } = boot({
    fragmentShader,
    height: window.innerHeight,
    vertexShader,
    width: window.innerWidth,
  });

  window.document.body.appendChild(renderer.domElement);

  const onWindowResize = makeWindowResizeHandler({
    material,
    renderer,
    window,
  });

  window.addEventListener("resize", onWindowResize, false);

  onWindowResize();

  const timer = { previousTime: 0, totalTime: 0 };

  loop({ camera, material, renderer, scene, timer });
};
