# Deskbottom Spool Holder

I started to have a lot of filaments and little space to store them so I figured
I could just hang them to the printer's tray.

<img src="./doc/holder.jpg" alt="Demo of the holder on my printer" style="width: 300px;" />

**Features**:

-   Fully adjustable in OpenSCAD
-   Lets you pass the filament directly to the printer
-   Holes to block the filament when not in use
-   Contains a column to stack successful
    [calibration shapes](https://github.com/Xowap/cr30-calibration) to help
    remember printing temperature and other settings for each filament

## Generating

You can just `make` in the repo's root to compile the OpenSCAD code into a STL
model. The file contains hopefully decent defaults so maybe it'll be fine for
you.

There are 3 main settings intended for end users to set:

-   **Table thickness** &mdash; How thick is your table? Put here a value bigger
    that the size of your table, a tight fit is not particularly desirable: on
    one hand the item is balanced so it doesn't rely on the lower part of the
    "clamp" to hold and on the other hand you want to be able to easily move
    your spools around, without having to force them into place.
-   **Spool width** &mdash; The width of the spool you're going to store here.
    The larger the width, the larger the holder, the less you can fit on your
    table. On the other hand you probably don't want to be printing a new holder
    every time you buy a new filament. Only you knows :)
-   **Spool radius** &mdash; The radius of the spool, which will lower the
    holder's cylinder in order to make the spool fit under the table.

## Printing

This is designed to be easy to print on a CR-30 or any other belt printer. It
doesn't require any supports for printing on a belt printer and I'm pretty sure
that it's fairly easy to print on a classical printer as well. All you need to
do is:

-   Put the "base side" against the belt/bed. That's the side that is the
    closest to you on the picture above.
-   Make sure that the spool arm/cylinder goes out first on a belt printer.

The model should be oriented correctly at import when using kiri:moto.

I print with 10% infill, but any setting you like will be fine I guess.
