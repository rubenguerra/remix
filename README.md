# remix
Un repositorio para los smart contract de la plataforma EVM.
 
 # contract Subasta
 Primera versión
 
// Este contracto consta de los parámetros:
beneficiary (direccion del beneficiario de la subasta y a quien le llega el monto)
auctionEndTime (tiempo de subasta)

// Variables de estado:
highestBidder: dirección de los ofertantes.
highestBid: monto de la oferta.

// Se crea un mapping para hacer los retiros de los montos remanentes, aquellos que no logran la compra.
// Este mapping relaciona las direcciones y los montos, llamado pendingReturns.

// Se crean dos eventos que permiten hacer cambios:
HighestBidIncreased, toma la dirección y el monto de las pujas.
AuctionEnded, que toma la oferta más alta y declara un ganador.

// Modificador
Se creó un modificador para que maneje la función withDraw que permite retirar los montos de las ofertas que no se tomaron.

// El contrato tiene 4 funciones:
Una función payable que va a recibir los ofrecimientos en la puja.

function bid()

// Y comienza con el requerimiento de tiempo
// Condiciona un monto mayor al 5 por ciento de la oferta
// y activa el evento para la puja

// Otra funcion para retornar montos de ofertas no ganadoras, con un monto al que se le resta el 2%.
function withdraw()

//que ejecuta el beneficiario.
// Y una función para terminar la subasta
function auctionEnd()

// por ultimo una función para visualizar los montos de acuerdo a la dirección
function getBidder(()



