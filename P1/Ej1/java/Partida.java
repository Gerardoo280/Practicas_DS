import java.util.ArrayList;
public abstract class Partida implements Runnable{ //Al utilizar Runnable hay que utilizar el método run que es obligatorio
    protected ArrayList<Jugador> jugadores;
    protected int duracion=60;
    public Partida(ArrayList<Jugador> jugadores){
        this.jugadores = jugadores;
    }
    public abstract void simular(); //porcentaje de abandono

    public abstract void run(); //este es el método obligatorio al implementar Runnable
}