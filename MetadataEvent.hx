class MetadataEvent extends flash.events.Event {
    // Identifier for the event
	static public var METADATA_EVENT="METADATA_EVENT";
    public var value : AudioMetadata;

    // Create a new event

    public function new(v : AudioMetadata){
		super(METADATA_EVENT);
		value = v;
    }
}
