# Dynamická DDNS u Wedosu (Docker image)
Docker image pro automatickou změnu IP adresy domény. Cron je součástí kontejneru.

## Jak to funguje?
Skript zjistí svoji ip adresu počítače, na kterém běží. Poté přeloží doménové jméno na IP adresu a obě IP adresy porovná. Pokud se liší, skript *wedos-updatedns.py* změní přes Wedos WAPI (rozhraní) IP adresu, kam má doména směřovat. Pak standardně čekáte až hodinu, než se změny projeví na všech DNS serverech.

## Prerekvizity, které musíme mít připravené v administraci Wedosu.
- nastavenou a uloženou A doménu, kterou chcete skriptem udržovat aktuální [návod Youtube](https://youtu.be/TX9eJdxUDcI), [návod v textové nápovědě s typy DNS adres](https://kb.wedos.com/cs/dns/wedos-dns/wedos-dns-zaznamy-domeny/)
> Nejčastěji vás budou zajímat A domény a CNAME (alias = povedou na stejnou IP adresu). A doména je example.com směřující na konkrétní IP adresu. CNAME můžete nastavit jako subdoménu something.example.com s adresou na example.com. Vřele doporučuji dát alias *.example.com , což přesměruje všechny subdomény na váš server a nemusíte je ručně vyjmenovávat. Případně vás budou zajímat ještě MX záznamy pro emailové adresy. Za zmínku stojí ještě formát AAA, což je to samé co A záznam, jen pro IPv6. Teoreticky by mohl tento skript fungovat pro IPv4 i IPv6, ale neměl jsem možnost IPv6 vyzkoušet.
- nastavené WAPI rozhraní ([návod k WAPI](https://kb.wedos.com/cs/wapi-api-rozhrani/zakladni-informace-wapi-api-rozhrani/wapi-aktivace-a-nastaveni/), rozsahy IP adres českých poskytovatelů: [tomasbenda.cz](https://www.tomasbenda.cz/2016/08/27/rozsah-ipv4-adres-pridelenych-pro-ceskou-republiku/) či [nirsoft.net](https://www.nirsoft.net/countryip/cz.html))

## Parametry spuštění
Parametry se zadávají jako proměnné prostředí při vytváření nebo spouštění kontejneru
 - `LOGIN` - E-mailová adresa vašeho Wedos účtu
 - `PASSWORD` - Heslo k Wedos WAPI účtu
 - `DOMAIN` - hlavní doména pod kterou změny provádíme
 - *(volitelné)* `SUBDOMAIN` - poddoména u které se má A záznam nastavit. Již musí existovat A záznam pod touhle doménou. V případě vynechání se záznam aplikuje na doménu druhého řádu.
 - *(volitelné)* `CRON_INTERVAL` - standardně je nastaven na 1x za hodinu (klasická cron expression)
### Příklady spuštění
1. Dynamické nastavení IP adresu A záznamu na doméně `subdomain.example.com`

`docker run -e LOGIN=user@example.com -e PASSWORD=passW0rd! -e DOMAIN=example.com -e SUBDOMAIN=subdomain shelll3/wedos-ddns`

2. Dynamické nastavení IP adresu A záznamu na doméně `example.com`

`docker run -e LOGIN=user@example.com -e PASSWORD=passW0rd! -e DOMAIN=example.com shelll3/wedos-ddns`

3. Dynamické nastavení IP adresu A záznamu na doméně `example.com` jednou za 30 min

`docker run -e LOGIN=user@example.com -e PASSWORD=passW0rd! -e DOMAIN=example.com -e CRON_INTERVAL="*/30 * * * *" shelll3/wedos-ddns`

## Automatické spouštění skriptu
Tato verze je upravena a automatické spouštění je již součástí samotného kontejneru, interval spouštění lze nastavit parametrem.
