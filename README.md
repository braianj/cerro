# Galería de Imágenes Cerro

Una galería web moderna para visualizar imágenes con filtros avanzados y funcionalidades de búsqueda.

## Filtros Disponibles

- **Fechas**: Filtrar por rango de fechas
- **Fotógrafo**: Seleccionar fotógrafo específico
- **Etiquetas**: Filtrar por etiquetas con conteo de imágenes
- **Favoritos**: Mostrar solo imágenes marcadas como favoritas
- **Color**: Por categoría (rojo, azul, ...) o por color exacto (hex/RGB, con
  gotero y tolerancia). Varios hex a la vez buscan fotos que contengan todos
  (ej. casco + pantalón). Al abrir una foto, su paleta es clickeable para
  buscar por esos colores. Compartible por URL (`?color=f24d7f,3a685e&tol=amplio`).
  El filtro persiste al cambiar de página, y "Buscar en todo el rango" recorre
  todas las páginas del rango de fechas con progreso y botón para detener
- **Paginación**: Configurable (50, 100, 200, 500, 1000, 2000, 5000 imágenes por página)

## Otras funciones

- **Barra de búsqueda fija**: el header queda pegado arriba y se compacta al
  scrollear, así los filtros y la paleta están siempre a mano
- **Compartir una foto**: al abrir una foto la URL apunta a ella
  (`?photo=<id>`) y el botón Compartir copia ese link (en celular abre el
  menú nativo). Quien lo abre cae en la misma vista con la foto en pantalla
