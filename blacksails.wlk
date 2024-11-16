class Monstruo{
    var property vitalidad
    const zonasAtacadas

    method peligrosidad() = vitalidad * self.velocidad()
    method esRapido()= self.velocidad() > 100
    method esPatetico() = zonasAtacadas.forEach{zona => !zona.esPatetico(self)}
    method masPeligrosoQue(num) = self.peligrosidad() > num
}

object sapoPepe inherits Monstruo(vitalidad = 9999999999999999,zonasAtacadas =[]){
    method velocidad() = 150000
    override method peligrosidad() = 2000000
    method esMasMaloKraken() = true
    override method esPatetico() = true
}

class HombreLobo inherits Monstruo{
    
    method velocidad() = 30 + 2*vitalidad
    method esMasMaloKraken() = vitalidad > 50
}

class Vampiro inherits Monstruo{

    method cambiarVelocidad(nuevaVelocidad) {velocidadVampiro.velocidad(nuevaVelocidad)}
    method velocidad() = velocidadVampiro.velocidad() 
    method esMasMaloKraken() = false 
}

object velocidadVampiro{
    var property velocidad = 100
}

class Dragon inherits Monstruo{
    var property velocidad
    const property esMasMaloKraken
}

class Zona{
    const property ataquesSufridos
    const property propiedad


    method nigthmareTeam(){
        const monstruos = #{}
        ataquesSufridos.forEach{ataque => monstruos.add(ataque.monstruoMasPeligroso())}
        return monstruos
    }

    method monstruosRapidos(){
        return ataquesSufridos.map{ataque => ataque.monstruos()}.flatten().asSet().filter{monstruo => monstruo.esRapido()}
    }

    method fueDestruida() = ataquesSufridos.any{ataque => ataque.nivelDevastacion() > self.resistencia()}

    method fechaDestruccion() {
        var ataque
        ataque = ataquesSufridos.filter{ataque => ataque.nivelDevastacion() > self.resistencia()}.take(1)
        return ataque.fecha()
    }

    method esPatetico(monstruo) {
        ataquesSufridos.any{ataque => ataque.fecha() > self.fechaDestruccion() && ataque.participa(monstruo)}
    }

    method esAldea() = propiedad == "aldea"
    method esCastillo() = propiedad == "castillo"

    method registrarAtaque(ataque){
        ataque.monstruos().filter{monstruo => if((self.esPatetico(monstruo) && self.esAldea()) || (self.esCastillo() && monstruo.masPeligrosoQue(256))){true}
        else{throw new MessageNotUnderstoodException(message = "no pasaron el filter")}}
    }
}

class Aldea inherits Zona{
    const property casas

    method resistencia(){
        return casas.sum{casa => casa.resistencia()}
    }
}

class Castillo inherits Zona{
    const property resistenciaCastillo

    method resistencia(){
        return 3000 + resistenciaCastillo
    }
}

class CastilloConMagos inherits Castillo{
    const magos
    override method resistencia(){
        return super() + magos.sum{mago => mago.poder()} + 20
    }
}

class Ataque{
    const property fecha
    const property monstruos

    method monstruoMasPeligroso(){
        return monstruos.max{monstruo => monstruo.peligrosidad()}
    }

    method esSerio() = monstruos.count{monstruo => monstruo.esMasMaloKraken()} >= 3

    method nivelDevastacion(){return monstruos.sum{monstruo => monstruo.peligrosidad()}}

    method participa(monstruo) = monstruos.contains(monstruo)
}

class Casa{
    const property resistencia
}