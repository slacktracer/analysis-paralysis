import {
  Color,
  Float32BufferAttribute,
  Mesh,
  OrthographicCamera,
  PlaneGeometry,
  Scene,
  ShaderMaterial,
  Vector2,
  Vector4,
  WebGLRenderer,
} from "three";

export const boot = ({
  fragmentShader,
  height,
  vertexShader,
  width,
}: {
  readonly fragmentShader: string;
  readonly height: number;
  readonly vertexShader: string;
  readonly width: number;
}) => {
  const renderer = new WebGLRenderer();

  const scene = new Scene();

  const camera = new OrthographicCamera(0, 1, 1, 0, 0.1, 1000);

  camera.position.set(0, 0, 1);

  const material = new ShaderMaterial({
    fragmentShader,
    uniforms: {
      colour1: { value: new Vector4(1, 1, 0, 1) },
      colour2: { value: new Vector4(0, 1, 1, 1) },
      resolution: { value: new Vector2(width, height) },
      time: { value: 0.0 },
    },
    vertexShader,
  });

  const geometry = new PlaneGeometry(1, 1);

  const colours = [
    new Color(0xff0000),
    new Color(0x00ff00),
    new Color(0x0000ff),
    new Color(0xf000f0),
  ]
    .map((item) => item.toArray())
    .flat();

  geometry.setAttribute("myStuff", new Float32BufferAttribute(colours, 3));

  const plane = new Mesh(geometry, material);

  plane.position.set(0.5, 0.5, 0);

  scene.add(plane);

  return {
    camera,
    material,
    renderer,
    scene,
  };
};
