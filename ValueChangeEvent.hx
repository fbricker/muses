class ValueChangeEvent extends flash.events.Event {
    // Identifier for the event

    static public var VALUE_CHANGE = "valueChange";
    public var value : Float;

    // Create a new event

    public function new(v : Float){
		super(VALUE_CHANGE);
		value = v;
    }
}
