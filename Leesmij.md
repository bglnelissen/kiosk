# Leesmij

Zo, wat goed dat je mij leest. Hierin zal ik uitleggen hoe dit systeem werkt.

<<<<<<< HEAD:USB Stick/Leesmij.md
#### Kiosk

De presentatie die `kiosk.odp` of `kiosk.ppt` of `kiosk.pptx` heet wordt afgespeeld na het opstarten (de eerste die wordt gevonden wordt afgespeeld). Om dit zonder al te veel problemen voor elkaar te krijgen moet de presentatie aan een paar voorwaarden voldoen:
=======
## kiosk.odp

**Automatisch afspelen.** De presentatie die `kiosk.odp` of `kiosk.ppt` of `kiosk.pptx` heet (allemaal kleine letters) wordt afgespeeld na het opstarten (de eerste die wordt gevonden wordt afgespeeld). Om dit zonder al te veel problemen voor elkaar te krijgen moet de presentatie aan een paar voorwaarden voldoen:
>>>>>>> 24158d057c3adb75af31ed927b516ea20c4c75c3:Leesmij.md

- De presentatie moet in de *basis ('root')* van de USB schijf staan om gevonden te worden.
- Dat ene slide vanzelf door gaat naar de volgende slide moet in de presentatie per slide worden meegegeven.
- Dat de presentatie aan het einde weer op nieuw begint moet ook worden meegegeven.

**Automatisch door de slides gaan** kan je zelf instellen.
Zo kan je het doen met LibreOffice:

1. Selecteer alle slides aan de linkerkant van het scherm
2. Slide (in de balk bovenin)
3. Slide transition (onderaan het menu)
4. In het menu rechts kies je voor:
    - Kies de Slide Transition die gepast is (bijv. 'Fade' of 'None')
    - Advance Slide
    - Automatically after: 40 seconden
    - Apply Transition to All Slides

**De presentatie aan het einde weer opnieuw te laten beginnen** kan je zelf instellen.
Zo kan je het doen met LibreOffice:

1. Slide Show (in de balk bovenin)
2. Slide Show Settings
3. Loop and repeat after 00:00:00

Om je te helpen is er een standaard presentatie die je kan wijzigen. De beste manier om dit te doen is om eerst een kopie te maken van die presentatie en daarna die presentatie te wijzigen. De map **Archief** is bedoelt om backups van de presentatie te bewaren.

Een makkelijke manier om een slide toe te voegen is door een andere slide te 'dupliceren'. Dupliceren kan door aan de linkerkant waar alle slides staan met de rechtermuisknop te klikken en dan te kiezen voor dupliceer. De nieuwe slide heeft dan al de eigenschappen die hij nodig heeft (bijv. dat de slide vanzelf doorgaat naar de volgende).


<<<<<<< HEAD:USB Stick/Leesmij.md
#### Archief

Er staat in de map `Archief` een voorbeeld presentatie die gebruikt kan worden. Laat altijd een copy in die map staan, dan weet je zeker dat je een backup hebt. Als je een presentatie hebt gemaakt kan je in de map `Archief` een copy zetten, ook als backup.

#### kiosk.sh

Er staat een bestandje kiosk.sh op de schijf. Dit bestand is noodzakelijk en zorgt er voor dat de presentatie werkt. Niet verwijderen dus ;)

#### Problemen?

Zorg dat alle stekkers en de USB stick goed zitten. Probeer opnieuw op te starten door de stekker eruit te halen, 10sec te wachten en dan de stekker er weer in te doen. De meeste problemen moeten hiermee op te lossen zijn. Succes en mailen kan altijd, b.g.l.nelissen@gmail.com

Grt Bas
=======
## Archief

Er staat in de map `Archief` een voorbeeld presentatie die gebruikt kan worden. Laat altijd een copy in die map staan, dan weet je zeker dat je een backup hebt. Als je een presentatie hebt gemaakt kan je in de map `Archief` een copy zetten, ook als backup.

## kiosk.sh

Er staat een bestandje kiosk.sh op de schijf. Dit bestand is noodzakelijk en zorgt er voor dat de presentatie werkt. Niet verwijderen dus ;)

Succes en mailen kan altijd.

Grt Bas

*b.g.l.nelissen@gmail.com*
>>>>>>> 24158d057c3adb75af31ed927b516ea20c4c75c3:Leesmij.md
