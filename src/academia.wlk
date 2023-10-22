class Cosa {

	const property volumen
	const property marca
	const property esMagica
	const property esUnaReliquia

	method utilidad() {
		return volumen + self.tresSiEsMagica() + self.cincoSiEsReliquia() + marca.aporte(self)
	}

	method tresSiEsMagica() {
		return if (esMagica) 3 else 0
	}

	method cincoSiEsReliquia() {
		return if (esUnaReliquia) 5 else 0
	}

}

class Academia {

	var property muebles

	method guardar(cosa) {
		self.validarGuardar(cosa)
		self.muebleAptoParaGuardar(cosa).guardar(cosa)
	}

	method validarGuardar(cosa) {
		if (not self.sePuedeGuardar(cosa)) {
			self.error("No se puede guardar")
		}
	}

	method sePuedeGuardar(cosa) {
		return not self.estaGuardada(cosa) && self.hayUnMuebleConEspacioPara(cosa)
	}

	method estaGuardada(cosa) {
		return muebles.any({ mueble => mueble.tieneGuardada(cosa) })
	}

	method enQueMuebleEsta(cosa) {
		return muebles.find({ mueble => mueble.tieneGuardada(cosa) })
	}

	method hayUnMuebleConEspacioPara(cosa) {
		return muebles.any({ mueble => mueble.puedeGuardar(cosa) })
	}

	method mueblesDisponiblesParaGuardar(cosa) {
		return muebles.filter({ mueble => mueble.puedeGuardar(cosa) })
	}

	method muebleAptoParaGuardar(cosa) {
		return muebles.find({ mueble => mueble.puedeGuardar(cosa) })
	}

	method cosasMenosUtiles() {
		return muebles.map({ mueble => mueble.cosaMenosUtil() })
	}

	method marcaMenosUtil() {
		return self.cosaMenosUtil().marca()
	}

	method cosaMenosUtil() {
		return self.cosasMenosUtiles().min({ cosa => cosa.utilidad() })
	}

	method removerMenosUtilesNoMagicas() {
		self.validarRemover()
		self.cosasMenosUtilesNoMagicas().forEach({ cosa => self.eliminarDelMueble(cosa)})
	}

	method cosasMenosUtilesNoMagicas() {
		return self.cosasMenosUtiles().filter({ cosa => not cosa.esMagica() })
	}

	method eliminarDelMueble(cosa) {
		self.enQueMuebleEsta(cosa).eliminar(cosa)
	}

	method validarRemover() {
		if (not self.tieneAlMenosTresMuebles()) {
			self.error("Se deben tener al menos tres muebles para remover estas cosas")
		}
	}

	method tieneAlMenosTresMuebles() {
		return muebles.size() >= 3
	}

}

class Mueble {

	const cosas = #{}

	method puedeGuardar(cosa)

	method precio()

	method tieneGuardada(cosa) {
		return cosas.contains(cosa)
	}

	method guardar(cosa) {
		cosas.add(cosa)
	}

	method utilidad() {
		return self.utilidadDeLasCosas() / self.precio()
	}

	method utilidadDeLasCosas() {
		return cosas.sum({ cosa => cosa.utilidad() })
	}

	method cosaMenosUtil() {
		return cosas.min({ cosa => cosa.utilidad() })
	}

	method eliminar(cosa) {
		cosas.remove(cosa)
	}

}

class Baul inherits Mueble {

	const volumenMaximo

	method volumenUsado() {
		return cosas.sum({ cosa => cosa.volumen() })
	}

	override method puedeGuardar(cosa) {
		return (cosa.volumen() + self.volumenUsado()) <= volumenMaximo
	}

	override method precio() {
		return volumenMaximo + 2
	}

	override method utilidad() {
		return super() + self.dosSiSonTodasReliquias()
	}

	method dosSiSonTodasReliquias() {
		return if (self.sonTodasReliquias()) 2 else 0
	}

	method sonTodasReliquias() {
		return cosas.all({ cosa => cosa.esUnaReliquia() })
	}

}

class BaulMagico inherits Baul {

	override method precio() {
		return super() * 2
	}

	override method utilidad() {
		return super() + self.cantidadDeElementosMagicos()
	}

	method cantidadDeElementosMagicos() {
		return cosas.count({ cosa => cosa.esMagica() })
	}

}

class GabineteMagico inherits Mueble {

	const precio

	override method puedeGuardar(cosa) {
		return cosa.esMagica()
	}

	override method precio() {
		return precio
	}

}

class Armario inherits Mueble {

	var property capacidadMaxima

	override method puedeGuardar(cosa) {
		return cosas.size() < capacidadMaxima
	}

	override method precio() {
		return capacidadMaxima * 5
	}

}

class Marca {

	method aporte(cosa)

}

object acme inherits Marca {

	override method aporte(cosa) {
		return cosa.volumen() / 2
	}

}

object fenix inherits Marca {

	override method aporte(cosa) {
		return if (cosa.esUnaReliquia()) 3 else 0
	}

}

object cuchuflito inherits Marca {

	override method aporte(cosa) {
		return 0
	}

}

