
import java.util.ArrayList;

public class Partidacasual extends Partida {

    public Partidacasual(ArrayList<Jugador> jugadores) {
        super(jugadores);
    }

    @Override
    public void simular() {
        int abandono = (int) (jugadores.size() * 0.1);
        for (int i = 0; i < abandono; i++) {
            int index = (int) (Math.random() * jugadores.size()); //Para eliminar un jugador aleatorio
            Jugador j = jugadores.remove(index);
            System.out.println("Jugador " + index + " ha abandonado la partida casual.");
        }
    }

    @Override
    public void run() {
        System.out.println("Partida Casual iniciada con " + jugadores.size() + " jugadores.");
        try {
            Thread.sleep(duracion / 2 * 1000); // mitad de la partida
            simular();                          // todos abandonan a la vez
            Thread.sleep(duracion / 2 * 1000); // resto de la partida
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Partida Casual finalizada. Jugadores restantes: " + jugadores.size());
    }
}
