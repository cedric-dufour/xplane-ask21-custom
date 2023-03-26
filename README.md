Customized Schleicher ASK 21 for X-Plane 12
=====

This repository contains the _changed_ (or _added_) resources to customize X-Plane 12 stock Schleicher ASK 21,
including:

* low-pass filtered mechanical, electronic and sound variometers, all based on X-Plane total energy
  values (albeit with different time constants)

Usage
-----

* Copy the existing "_Aircraft/Laminar Research/Schleicher ASK 20_" (folder) into
  the "_Aircraft/Custom Aircrafts/Custom ASK 21_" (folder)

* Overwrite the content (resources) of the "_Aircraft/Custom Aircrafts/Custom ASK 21_"
  with those of this repository


Internal
-----

Those changes were implemented:

* using custom [xlua](https://github.com/X-Plane/XLua)-ed variometer data references,
  in [ask21_variometer.lua](./plugins/xlua/scripts/ask21_variometer/ask21_variometer.lua)

* referred to in the updated instruments objects:
  - [variometer.obj](./objects/instruments/variometer/variometer.obj)
  - [totalenergy.obj](./objects/instruments/totalenergy/totalenergy.obj)

* using an additional, custom FMOD _Bank_ and _Event_:
  - as per ad-hoc [FMOD project](./fmod/source)
  - and updated [ASK21.snd](./fmod/ASK21.snd) and [GUIDS.txt](./fmod/GUIDS.txt)
