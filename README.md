# EMS Energy - Ignition 8.3 Project

Projekt przedstawia system **Energy Management System (EMS)** wykonany w środowisku **Ignition 8.3**. System służy do monitorowania parametrów energii elektrycznej, prezentacji danych pomiarowych, analizy zużycia oraz obsługi alarmów.

Projekt został przygotowany jako aplikacja przemysłowa wykorzystująca moduł **Perspective**, bazę danych **PostgreSQL**, tagi Ignition, historian, symulator urządzenia oraz skrypty backendowe w Project Library.

---

## Cel projektu

Celem projektu było stworzenie kompletnego systemu EMS dla modułu Energy, który umożliwia:

- monitorowanie aktualnych parametrów energetycznych,
- analizę zużycia energii w czasie,
- porównywanie zużycia według lokalizacji,
- przegląd liczników energii,
- filtrowanie danych po lokalizacji, liczniku i zakresie czasu,
- obsługę aktywnych alarmów,
- archiwizację danych pomiarowych,
- prezentację danych w czytelnym dashboardzie operatorskim.

---

## Technologie

Projekt wykorzystuje:

- Ignition 8.3
- Ignition Perspective
- PostgreSQL
- pgAdmin 4
- SQL Historian
- Programmable Device Simulator
- Jython / Project Library Scripts
- Alarm Status Table
- Power Chart / wykresy trendów

---
