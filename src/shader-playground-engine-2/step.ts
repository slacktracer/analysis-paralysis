import type { ShaderMaterial } from "three";

export const step = ({
  material,
  timeElapsed,
  timer,
}: {
  readonly material: ShaderMaterial;
  readonly timeElapsed: number;
  readonly timer: { totalTime: number };
}) => {
  const timeElapsedS = timeElapsed * 0.001;

  timer.totalTime += timeElapsedS;

  material.uniforms.uTime.value = timer.totalTime;
  material.uniforms.time.value = timer.totalTime;
};
