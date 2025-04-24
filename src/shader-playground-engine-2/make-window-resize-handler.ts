/// <reference lib="dom" />
import { ShaderMaterial, Vector2, WebGLRenderer } from "three";

export const makeWindowResizeHandler = ({
  material,
  renderer,
  window,
}: {
  readonly material: ShaderMaterial;
  readonly renderer: WebGLRenderer;
  readonly window: Window;
}) => {
  return () => {
    const dpr = window.devicePixelRatio;

    const canvas = renderer.domElement;

    canvas.style.width = window.innerWidth + "px";
    canvas.style.height = window.innerHeight + "px";

    const w = canvas.clientWidth;
    const h = canvas.clientHeight;

    renderer.setSize(w * dpr, h * dpr, false);

    material.uniforms.uResolution.value = new Vector2(
      window.innerWidth * dpr,
      window.innerHeight * dpr,
    );

    material.uniforms.resolution.value = new Vector2(
      window.innerWidth * dpr,
      window.innerHeight * dpr,
    );
  };
};
