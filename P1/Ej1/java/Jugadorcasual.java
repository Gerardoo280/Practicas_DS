public class Jugadorcasual extends Jugador{
    public Jugadorcasual(int id){
        super(id);
    }

    @Override
    public String getModalidad(){
        return "Casual";
    }
}