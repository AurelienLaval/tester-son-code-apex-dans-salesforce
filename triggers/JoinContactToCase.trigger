/**
Trigger se déclenchant avant la création et la mise à jours de cases 
Recherche le contact correspondant à l'adresse mail du champs 'SuppliedMail' du case.
Si le contact n'existe pas, il est créé et rattaché au case.
**/
trigger JoinContactToCase on Case (before insert, before update) {

	public map<String, Contact> contactsMap = new map<String, Contact>();
	public map<String, Contact> createdContacts;
	public List<String> mailsList = new List<String>();
	public List<Contact> contactToCreate = new List<Contact>();
	public List<Integer> remainderCases = new List<Integer>();
	Integer caseNumber = 0;
	
	// Pour chaque case
	for(Case myCase : Trigger.new){
		
		// Si le contactId est null mais que le champs suppleidMail ne l'est pas
		if(myCase.ContactId == null && myCase.SuppliedEmail != null){
			
			// Récupération de l'adresse mail
			mailsList.add(myCase.SuppliedEmail);
		}		
	}
	
	// Récupération des contacts associés aux adresses mails
	contactsMap = getContacts(mailsList);
	
	// Parcours des cases
	for(Case myCase : Trigger.new){
		
		if(myCase.ContactId == null && myCase.SuppliedEmail != null){
			
			// Si le contact avec l'adresse mail du case existe dans la map
			if(contactsMap.containsKey(myCase.SuppliedEmail)){
				myCase.ContactId = contactsMap.get(myCase.SuppliedEmail).Id;
			}
			// On ajoute le contact à la liste pour le créer par la suite
			else{
				contactToCreate.add(new Contact(
					Email = myCase.SuppliedEmail,
					LastName = myCase.SuppliedEmail
				));
				
				// On indique quel case il reste à relier à un contact
				remainderCases.add(caseNumber);
			}
		}
		
		caseNumber++;
	}
	
	// Création des contacts
	insert contactToCreate;
	
	// Récupération des contacts créés sous formes de map<email, contact>
	createdContacts = getContactsByMap(contactToCreate);
	
	// Pour case qu'il reste à relier à un contact
	for(Integer theCaseNumber : remainderCases){
		
		// Si le contact de l'adresse mail du case est un contact venant d'être créé
		if(createdContacts.containsKey(Trigger.new[theCaseNumber].SuppliedEmail)){
			
			// Liaison du case avec le contact
			Trigger.new[theCaseNumber].ContactId = createdContacts.get(Trigger.new[theCaseNumber].SuppliedEmail).Id;
		}
	}
	
	/** Retourne les contacts associés aux adresses mails donnés en paramètre sous forme de map<mail, contact> **/
	public map<String, Contact> getContacts(List<String> mails){
		
		return getContactsByMap([
			SELECT Id, Email
			FROM Contact
			WHERE Email IN :mails
		]);
	}
	
	/** Retourne les contacts de la liste sous forme de map<mail, contact> **/
	public map<String, Contact> getContactsByMap(List<Contact> contactsList){
		map<String, Contact> result = new map<String, Contact>();
		
		// Insert des contacts dans la map avec en clé, l'adresse mail
		for(Contact myContact : contactsList){
			result.put(myContact.Email, myContact);
		}
		
		return result;
	}
}