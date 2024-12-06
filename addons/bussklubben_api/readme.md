# Bussklubben API

Ett API för Godot som kan kommunicera med Bussklubben och wrappar spelet med Bussklubbens interface.

## Installation

Börja med att ladda ned detta repo:t och placera det i _"addons"_ -mappen i ditt Godot-projekt
BILD

Gå in i _"Project"_ -> _"Project Settings"_ -> _"Plugins"_ och bocka i _"Bussklubben API"_
BILD

## Implementation

I detta API finns fyra statiska funktioner som bör implementeras

- game_loaded
- set_score
- game_done
- register_restart

### game_loaded

Anropa ´BussklubbenAPI.game_loaded()´ när spelet har laddat färdigt och är redo. Detta döljer laddskärmen som html-wrappern kommer att visa när spelet är exporterat.

### set_score

Använd ´BussklubbenAPI.set_score(int)´ för att meddela API:t vad spelaren har för poäng.

### game_done

Anropa ´BussklubbenAPI.game_done()´ när spelaren har vunnit eller förlorat, och highscore-listan ska visas.

### register_restart

Efter att _"game_done"_ har anropats och highscore-listan visas får spelaren alternativt att starta om. Trycker spelaren på den knappen döljs listan och spelaren får åtkomst till spelet igen, men API:t försöker också skicka ett anrop till spelet. För att koppla anropet till att spelet körs om måste ett _"callback"_ registreras i koden.

Först och främst måste någon sorts restart-funktion finnas i koden. Den kan t.ex. se ut så här:

```
func reset_game(args) -> void:
	set_failed(false)
	set_playing(false)
	set_score(0)
```

Notera att argumentet _"args"_ finns med, även fast det inte används. Det är ett krav för att JavaScript-modulen ska kunna anropa funktionen.

Vidare ska en referens till ett _"callback"_ definieras i toppen av samma fil, t.ex.:

```
var _restart_callback_ref = JavaScriptBridge.create_callback(reset_game)
```

Till sist måste den även registreras till API:t, det bör göras i _"\_ready()"_ funktionen och det kan se ut så här:

```
BussklubbenAPI.register_restart(_restart_callback_ref)
```

## Anpassning

När spelet exporteras blir den wrappad av en HTML-mall som innehåller en laddskärm som är standard för alla Bussklubben-spel. För att laddskärmen ska visa rätt logga måste filen _"logo.png"_ ändras. Den finns i mappen _"images"_ som ligger i API-mappen.

## Export

Spelet måste exporteras som ett webb-spel. I fönstret _"Project"_ -> _"Export..."_ ska _"Web"_ väljas som preset. Bland exportparametrarna till höger måste _"Cusom HTML Shell"_ bytas. Tryck på filväljaren till höger och välj sedan filen _"shell.html"_ som ligger bland API-filerna. Detta gör så att spelet wrappas av Bussklubbens interface.

När du sedan väljer att exportera projektet kommer alla filer som behövs för Bussklubbens interface att kopieras med, inklusive din logga som ligger i _"images"_.

## Testning

För att kunna testa spelet med Bussklubbens interface måste spelet exporteras. Funktionen _"Run in browser"_ i Godot fungerar inte med Bussklubbens externa script.

När du väl exporterat filerna rekommenderas [http-server](https://www.npmjs.com/package/http-server) för att hosta en webbserver lokalt för att testa spelet med. Normalt sett hostar den till adressen _"localhost:8080"_.
