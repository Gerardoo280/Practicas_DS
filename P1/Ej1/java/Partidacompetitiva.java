import java.util.ArrayList;

public class Partidacompetitiva extends Partida {

    private double probabilidad = 0.2;

    public Partidacompetitiva(ArrayList<Jugador> jugadores) {
        super(jugadores);
    }

    @Override
    public void simular() {
        int abandono = (int) (jugadores.size() * probabilidad);
        for (int i = 0; i < abandono; i++) {
            int index = (int) (Math.random() * jugadores.size()); //Para eliminar un jugador aleatorio
            Jugador j = jugadores.remove(index);
            System.out.println("Jugador " + index + " ha abandonado la partida competitiva.");
        }
    }

    @Override
    public void run() {
        System.out.println("Partida Competitiva iniciada con " + jugadores.size() + " jugadores.");
        try {
            Thread.sleep(duracion / 2 * 100); // mitad de la partida
            simular();                          // todos abandonan a la vez
            Thread.sleep(duracion / 2 * 100); // resto de la partida
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Partida Competitiva finalizada. Jugadores restantes: " + jugadores.size());
    }
}
