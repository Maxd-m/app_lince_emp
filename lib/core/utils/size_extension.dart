import 'package:flutter/material.dart';

/*Nota: Vamos a crear la primera extensión que hemos utilizado.
Las extensiones son una forma de agragar funcionalidades a las clases
existentes sin tener que modificarlas directamente.

En este caso le vamos a añadir una extensión a BuilContext, su función
será obtener el tamaño de la pantalla para hacer responsive el diseño de
 la aplicación.

*/

//Aqui le decimos 'quieo agreagar nuevas funciones a BuildContext'
extension SizeExtensions on BuildContext {
  /* Nota: Recuerda las funciones Anonimas, son funciones que no tienen un nombre
específico y se pueden usar directamente sin necesidad de ser asignadas a una variable.
En este caso, estamos definiendo dos funciones anónimas dentro de la extensión
SizeExtensions: wP y hP. Estas funciones toman un porcentaje como argumento y
 devuelven el ancho o alto de la pantalla multiplicado por ese porcentaje,
 respectivamente. Esto es útil para crear diseños
 */

  //MediaQuery es una clase que nos permite obtener información sobre el
  //tamaño de la pantalla y otras características del dispositivo.
  double wP(double percent) => MediaQuery.of(this).size.width * (percent / 100);
  double hP(double percent) => MediaQuery.of(this).size.height * (percent / 100);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
