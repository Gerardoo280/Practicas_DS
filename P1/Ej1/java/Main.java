
import java.util.ArrayList;

public class Main {

    public static void main(String[] args) {
        int N = 10; // número de jugadores

        // Crear jugadores con cada factoría
        Factoriapartidayjugador factoriaComp = new Factoriacompetitiva();
        Factoriapartidayjugador factoriaCasual = new Factoriacasual();

        ArrayList<Jugador> jugadoresComp = new ArrayList<>();
        ArrayList<Jugador> jugadoresCasual = new ArrayList<>();

        for (int i = 0; i < N; i++) {
            jugadoresComp.add(factoriaComp.crearJugador(i));
            jugadoresCasual.add(factoriaCasual.crearJugador(i));
        }

        // Crear partidas
        Partida partida1 = factoriaComp.crearPartida(jugadoresComp);
        Partida partida2 = factoriaCasual.crearPartida(jugadoresCasual);

        // Lanzar hebras simultáneas
        Thread t1 = new Thread(partida1);
        Thread t2 = new Thread(partida2);
        t1.start();
        t2.start();
    }
}
