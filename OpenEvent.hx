import flash.events.Event;
import flash.media.SoundChannel;

// OpenEvent class

class OpenEvent extends Event
{
    public var channel : SoundChannel;

    public function new(channel : SoundChannel)
    {
	super(Event.OPEN);
	this.channel = channel;
    }
}
