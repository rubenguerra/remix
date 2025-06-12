# remix
Un repositorio para los smart contract de la plataforma EVM.
 
 # contract Subasta
 ## Version 3
 ## Para su corrección.
 
// Este contracto consta de varios parámetros:
beneficiary (direccion del beneficiario de la subasta y a quien le llega el monto)
auctionEndTime (tiempo de subasta)

// Se agregó una constante que contiene un tiempo para la oferta: 10 minutos.

// Variables de estado:
highestBidder: dirección de los ofertantes.
highestBid: monto de la oferta.

// Se crea un mapping para hacer los retiros de los montos remanentes, aquellos que no logran la compra.
// Este mapping relaciona las direcciones y los montos, llamado pendingReturns.

// Se creo un struct para guardar las informaciones de los ofertantes, dirección y montos de las pujas.

// Se crean dos eventos que permiten hacer cambios:
HighestBidIncreased, toma la dirección y el monto de las pujas.
AuctionEnded, que toma la oferta más alta y declara un ganador.

// Modificador
Se creó un modificador para que el beneficiario maneje la función auctionEnd que permite pagar el monto más alto al beneficiario.

// El contrato tiene 4 funciones:
Una función payable que va a recibir los ofrecimientos en la puja.

function bid()
// Y comienza con el requerimiento de tiempo
// Condiciona un monto mayor al 5 por ciento de la oferta
// Recoge los datos de los ofertantes y los guarda en un struct
// y activa el evento para la puja

// Otra funcion para retornar montos de ofertas no ganadoras, con un monto al que se le resta el 2%.
function withDraw()

// Y una función para terminar la subasta y enviar el pago que solo es activada por el beneficiario.
function auctionEnd()

// Por ultimo una función para visualizar las direcciones y las ofertas hechas durante la subasta.
function getBidder(()



