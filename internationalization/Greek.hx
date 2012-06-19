package internationalization;


class Greek extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Αναπαραγωγή");
		setText("stop","Διακοπή");
		setText("ioError","Σφάλμα δικτύου");
		setText("loadComplete","Σφάλμα: η μεταφόρτωση ολοκληρώθηκε");
		setText("soundComplete","Σφάλμα: ο ήχος ολοκληρώθηκε");
		setText("volume","Ένταση");
		setText("securityError","Σφάλμα ασφαλείας");
		setText("about","Περί του FFMp3...");		
		setText("version", "Έκδοση");
		setText("intro","Εισαγωγή");
	}
}