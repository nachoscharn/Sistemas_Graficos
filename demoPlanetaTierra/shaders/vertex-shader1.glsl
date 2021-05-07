
// atributos del vértice (cada uno se alimenta de un ARRAY_BUFFER distinto)
//lo que entra al programa

attribute vec3 aPosition;//posicion (x,y,z)
attribute vec3 aNormal;//vector normal (x,y,z)
attribute vec2 aUv;//coordenadas de texture (x,y)  x e y (en este caso) van de 0 a 1

// variables Uniform (son globales a todos los vértices y de solo-lectura)
//variables globales 
uniform mat4 uMMatrix;// matriz de modelado
uniform mat4 uVMatrix;// matriz de vista
uniform mat4 uPMatrix;// matriz de proyección
uniform mat3 uNMatrix;// matriz de normales

uniform float time;// tiempo en segundos

uniform sampler2D uSampler;// sampler de textura de la tierra, objeto especial que permite leer de una textura info

// variables varying (comunican valores entre el vertex-shader y el fragment-shader), son variables de salida del vertex y de entrada del fragment
// Es importante remarcar que no hay una relacion 1 a 1 entre un programa de vertices y uno de fragmentos
// ya que por ejemplo 1 triangulo puede generar millones de pixeles (dependiendo de su tamaño en pantalla)
// por cada vertice se genera un valor de salida en cada varying.
// Luego cada programa de fragmentos recibe un valor interpolado de cada varying en funcion de la distancia
// del pixel a cada uno de los 3 vértices. Se realiza un promedio ponderado

varying vec3 vWorldPosition;
varying vec3 vNormal;
varying vec2 vUv;

// constantes

const float PI=3.141592653;

void main(void){
    //el programa lo que haces es aplicar transformacions a partir de matrices para dibujar lo que quiero
    // se pasan los atributos a variables temporales, ya que de por si son unicamente de lecturas y no pueden ser modificadas
    vec3 position=aPosition;
    vec3 normal=aNormal;
    vec2 uv=aUv;
    
    vec4 textureColor=texture2D(uSampler,vec2(uv.s,uv.t));
    
    // **************** EDITAR A PARTIR DE AQUI *******************************
    
    //Por medio de la textura que se encuentra en el vector UV de 2 dimensiones (imagen del mapa)
    // se modifica el vector posicion, y a su ves se corren las coordenadas de x y z para que gire con respecto al eje Y en el centro del mapa
    position=vec3(uv.x-0.5,0,uv.y-0.5);

    // ************************************************************************
    //tomamos la posicion del vertice, lo multiplicamos por la matriz de modelado, obteniendo la posicion original en el espacio del mundo
    vec4 worldPos=uMMatrix*vec4(position,1.);
    //luego se aplica la matriz de vista y se obtiene la posicion en el espacio de camara y por ulimto la matriz de proyection para obteener la coordenada en espacio de pantalla
    //espacio normalizado que luego se transforma en 2D, para que el raterizador sabe donde dibujar en 2d el triangulo y puede convertirlo en fragmentos luego.

    gl_Position=uPMatrix*uVMatrix*worldPos;                 // la posocicion es obligatoria, tiene que salir si o si
    
    //y se devuelven 3 atributos mas opcionales, como son variables varing son la salida de mi vertex shader
    
    //calculos de iluminacion
    vWorldPosition=worldPos.xyz;
    vNormal=normalize(uNMatrix*aNormal);
    vUv=uv;
}