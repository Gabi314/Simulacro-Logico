# Archovo prolog vacio
%%Toy Story
%%Tenemos la siguiente base de conocimientos de ejemplo:
% Relaciona al dueño con el nombre del juguete
%%y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(andy, buzz, 7).
duenio(sam, jessie, 3).
duenio(gabi,seniorCaraDePapa,4).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([ original(pieIzquierdo),original(pieDerecho),repuesto(nariz) ])).
juguete(muniecaStacyMalibu,deAccion(stacyMalibu, [original(sombrero)])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, [original(sombrero)])).
% Dice si una persona es coleccionista
esColeccionista(sam).

/*
Resolver los siguiente requerimientos:
Nota: siempre que nos refiramos al functor que representa al juguete le diremos 
“juguete”. Y siempre que nos refiramos al átomo con su nombre, le diremos 
“nombre del juguete”
*/
/*1. a. tematica/2: relaciona a un juguete con su temática. 
La temática de los cara de papa es caraDePapa.*/

tematica(Juguete,Tematica):-
juguete(_,Juguete),
tematicaJuguete(Juguete,Tematica).

tematicaJuguete(deTrapo(Tematica),Tematica).

tematicaJuguete(deAccion(Tematica,_),Tematica).

tematicaJuguete(miniFiguras(Tematica,_),Tematica).

tematicaJuguete(caraDePapa(_),caraDePapa).

/*
1. b. esDePlastico/1: Nos dice si el juguete es de plástico, lo cual es verdadero 
sólo para las miniFiguras y los caraDePapa.
*/
esDePlastico(miniFiguras(Tematica, CantidadDeFiguras)):-
    tematica(miniFiguras(Tematica,CantidadDeFiguras),Tematica).

esDePlastico(Juguete):-
    tematica(Juguete,caraDePapa).
/*
1. c. esDeColeccion/1:Tanto lo muñecos de acción como los cara de papa son de 
colección si son raros, los de trapo siempre lo son, y las mini figuras, nunca.
*/

esDeColeccion(deAccion(Tematica,Partes)):-
    esRaro(deAccion(Tematica,Partes)).

esDeColeccion(caraDePapa(Partes)):-
    esRaro(caraDePapa(Partes)).

esDeColeccion(deTrapo(Tematica)):-
    tematica(deTrapo(Tematica),Tematica).

/*
2. amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no sea 
de plástico que tiene hace más tiempo. Debe ser completamente inversible.
*/

amigoFiel(Duenio,NombreJuguete1):-
    duenio(Duenio,NombreJuguete1,Anios1),
    amigoFielJuguete(Duenio,NombreJuguete1,Anios1),
    forall(amigoFielJuguete(Duenio,_,Anios2),Anios2=<Anios1).

amigoFielJuguete(Duenio,NombreJuguete,Anios):-
    duenio(Duenio,NombreJuguete,Anios),
    juguete(NombreJuguete,Juguete),
    not(esDePlastico(Juguete)).


/*
3. superValioso/1: Genera los nombres de juguetes de colección que tengan 
todas sus piezas originales, y que no estén en posesión de un coleccionista.
*/
   
superValioso(Juguete):-
    esDeColeccion(Juguete),
    juguete(NombreJuguete,Juguete),
    not(esPosesionDeColeccionista(NombreJuguete)),
    tieneTodasSusPiezasOriginales(Juguete).

esPosesionDeColeccionista(NombreJuguete):-
    duenio(Duenio,NombreJuguete,_),
    esColeccionista(Duenio).

tieneTodasSusPiezasOriginales(Juguete):-
    pieza(Juguete,_),
    forall(pieza(Juguete,Pieza),esOriginal(Pieza)).

pieza(Juguete,Pieza):-
    listaPiezas(Juguete,Piezas),
    member(Pieza,Piezas).

listaPiezas(deAccion(Tematica,Piezas),Piezas):-
    juguete(_,deAccion(Tematica,Piezas)).

listaPiezas(deAccion(Tematica,Piezas),Piezas):-
    esRaro(deAccion(Tematica,Piezas)).

listaPiezas(caraDePapa(Piezas),Piezas):-
    juguete(_,caraDePapa(Piezas)).

esOriginal(original(_)).
/*
4. dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le 
pertenezcan que hagan buena pareja. Dos juguetes distintos hacen buena pareja
si son de la misma temática. Además woody y buzz hacen buena pareja. 
Debe ser complemenente inversible.

*/
duoDinamico(Duenio,NombreJuguete1,NombreJuguete2):-
    duenio(Duenio,NombreJuguete1,_),
    duenio(Duenio,NombreJuguete2,_),
    hacenBuenaPareja(NombreJuguete1,NombreJuguete2).

hacenBuenaPareja(NombreJuguete1,NombreJuguete2):-
    juguete(NombreJuguete1,Juguete1),
    juguete(NombreJuguete2,Juguete2),
    tematica(Juguete1,Tematica),
    tematica(Juguete2,Tematica),
    NombreJuguete1\=NombreJuguete2.

hacenBuenaPareja(woody,buzz).
hacenBuenaPareja(buzz,woody).

/*5. felicidad/2:Relaciona un dueño con la cantidad de felicidad
 que le otorgan todos sus juguetes:
● las minifiguras le dan a cualquier dueño 20 * la cantidad de 
figuras del conjunto
● los cara de papas dan tanta felicidad según que piezas tenga: 
las originales dan 5, las de repuesto,8.
● los de trapo, dan 100
● Los de accion, dan 120 si son de coleccion y el dueño es
 coleccionista. Si no dan lo mismo que los de trapo.
Debe ser completamente inversible.

*/

felicidad(Duenio,FelicidadTotal):-
    duenio(Duenio,_,_),
    findall(Felicidad,felicidadJuguetes(Duenio,Felicidad),ListaFelicidad),
    sumlist(ListaFelicidad,FelicidadTotal).

felicidadJuguetes(Duenio,Felicidad):-
    duenio(Duenio,NombreJuguete,_),
    juguete(NombreJuguete,Juguete),
    tipoFelicidad(Juguete,Felicidad,Duenio).


tipoFelicidad(miniFiguras(_,Cantidad),Felicidad,_):-
    Felicidad is 20*Cantidad.

tipoFelicidad(deTrapo(_),100,_).   

tipoFelicidad(deAccion(Tematica,Partes),120,Duenio):-
    felicidadColeccion(Duenio,deAccion(Tematica,Partes)).

tipoFelicidad(deAccion(Tematica,Partes),100,Duenio):-
    not(felicidadColeccion(Duenio,deAccion(Tematica,Partes))).

tipoFelicidad(caraDePapa(Piezas),Felicidad,_):-
   juguete(_,caraDePapa(Piezas)), 
   findall(Pieza,piezasOriginalesPapa(Pieza,Piezas),PiezasOriginales),
   findall(Pieza,piezasNoOriginalesPapa(Pieza,Piezas),PiezasNoOriginales),
   length(PiezasOriginales, CantPiezasOriginales),
   length(PiezasNoOriginales, CantPiezasNoOriginales),
   Felicidad is 5 * CantPiezasOriginales + 8 * CantPiezasNoOriginales.

felicidadColeccion(Duenio,deAccion(Tematica,Partes)):-
    esDeColeccion(deAccion(Tematica,Partes)),
    esColeccionista(Duenio).

piezasOriginalesPapa(Pieza,Piezas):-
    member(Pieza,Piezas),
    esOriginal(Pieza).

piezasNoOriginalesPapa(Pieza,Piezas):-
    member(Pieza,Piezas),
    not(esOriginal(Pieza)).


/*

6. puedeJugarCon/2: Relaciona a alguien con un nombre de juguete cuando puede jugar con él.
Esto ocurre cuando:
● este alguien es el dueño del juguete
● o bien, cuando exista otro que pueda jugar con este juguete y pueda prestárselo

*/

puedeJugarCon(Duenio,NombreJuguete):-
    duenio(Duenio,NombreJuguete,_).

puedeJugarCon(Duenio1,NombreJuguete):-
    duenio(Duenio1,_,_),
    duenio(Duenio2,NombreJuguete,_),
    puedePrestar(Duenio2,Duenio1),
    Duenio1\=Duenio2.

puedePrestar(Duenio2,Duenio1):-
    cantJuguetes(Duenio1,CantJuguetesDuenio1),
    cantJuguetes(Duenio2,CantJuguetesDuenio2),
    CantJuguetesDuenio2>CantJuguetesDuenio1.

cantJuguetes(Duenio,CantJuguetesDuenio):-
    findall(NombreJuguete,duenio(Duenio,NombreJuguete,_),JuguetesDuenio),
    length(JuguetesDuenio,CantJuguetesDuenio).

/*
7. podriaDonar/3: relaciona a un dueño, una lista de
juguetes propios y una cantidad de felicidad;
cuando entre todos los juguetes de la lista le generan menos que esa
cantidad de felicidad. Debe ser completamente inversible.
*/


podriaDonar(Duenio,Juguetes,CantFelicidadDonacion):-
    duenio(Duenio,_,_),
    forall(member(Juguete,Juguetes),sonPropiosDelDuenio(Duenio,Juguete)),
    cantFelicidadLista(Juguetes,CantFelicidadLista,Duenio),
    CantFelicidadLista<CantFelicidadDonacion.

sonPropiosDelDuenio(Duenio,Juguete):-
    juguete(NombreJuguete,Juguete),
    duenio(Duenio,NombreJuguete,_).

cantFelicidadLista(Juguetes,CantFelicidadLista,Duenio):-
    duenio(Duenio,_,_),
    member(Juguete,Juguetes),
    findall(Felicidad,tipoFelicidad(Juguete,Felicidad,Duenio),ListaFelicidad),
    sumlist(ListaFelicidad,CantFelicidadLista).


/*8. Comentar dónde se aprovechó el polimorfismo

-En el ejercicio 1) se aprovecha el polimorfismo en tematica ya que se crearon
varias clausulas tematicaJuguete (una por cada tipo de juguete) para que tematica pueda delegar apropiadamente
evitando repetir logica.
-En el ejercicio 3) tambien se aprovecha con pieza y listaPieza
- En el 5) con felicidadJuguetes y tipoFelicidad
- En el 7) con cantFelicidadLista y tipoFelicidad

*/