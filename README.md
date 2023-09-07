# RickAndMorty

API used: https://rickandmortyapi.com/

The inital idea consisted in just the wiki part, where all characters are shown with their images and names. When tapping in any character, his ID is opened, showing more info about him. Only one ID is shown at once. When tapping in the ID it dissapears and the character is shown again as just an image an his name.

The loading of these characters is done by pagination. The inital screen just loads the first page and the consecutive ones are loaded only when needed, that is to say, when the user scrolls and is about to reach the last loaded characters.

There is the posibility of filtering the characters by tapping the top right icon. There are 5 different filters available and there can be combined as desired. If at least one character macthes the filter it/they are shown, if not, the filter resets to his previous state and a message is shown. The active filter combination can be easily cleared.

All the service responses and images are saved to cache using Realm.


After the development of the wiki came the second part of the project, the fun idea. This consisted in a quiz where the user needs to guess all the characters appearing in a random episode. For this, some extra info was needed, such as the cover and the synopsis of the episode, which was not included in the API response. In order to get it a "GET" call is done to the episode in the https://rickandmorty.fandom.com/ and the HTML is parsed.

The episode can be refreshed for a new one one tapping the top right icon.

Unit test have been added in order to test the Presenters when the logic is done and the Models. This tests have been automatizated via Fastlane. For them to run execute "fastlane tests" in the terminal and a "test_output" folder will be created with "index.html" inside, which shows the test coverage.



Improvement points for the future:

    - In order to guess the character and select a random episode, all the episodes and character names are needed. This forces to retrieve all the characters from the API, calling all the character pages. This is very inefficient.
    - Add some UX while all characters are loading.
    - Add Alamofire to manage service calls.
    - The most fun idea was to add Rick's voice lines. This was not developed because is not currently supported on simulators and was not testable.
    - Strings are set manually, should localize them or move them to a more managable context.
    - Some error handling needs to be done.
    - The component TextField+TableView where the characters name are searched in the quiz should be refactorized to a component.
    
    
P.S: Usage of Gloss for model parsing was debated, but in their github page says "Gloss has been deprecated in favor of Swift's Codable framework."
