import java.util.ArrayList;

public class Factoriacasual implements Factoriapartidayjugador {

    @Override
    public Partida crearPartida(ArrayList<Jugador> jugadores) {
        return new Partidacasual(jugadores);
    }

    @Override
    public Jugador crearJugador(int id) {
        return new Jugadorcasual(id);
    }
}
