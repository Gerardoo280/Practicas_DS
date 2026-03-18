import java.util.ArrayList;

public class Factoriacompetitiva implements Factoriapartidayjugador {

    @Override
    public Partida crearPartida(ArrayList<Jugador> jugadores) {
        return new Partidacompetitiva(jugadores);
    }

    @Override
    public Jugador crearJugador(int id) {
        return new Jugadorcompetitivo(id);
    }
}
