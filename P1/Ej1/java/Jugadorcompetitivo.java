public class Jugadorcompetitivo extends Jugador {
    public Jugadorcompetitivo(int id) {
        super(id);
    }

    @Override
    public String getModalidad() {
        return "Competitiva";
    }
}