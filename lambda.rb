#Function for installing any gems that I want to use
def installing_missing_gems(&block)
    yield
  rescue LoadError => e
    gem_name = e.message.split('--').last.strip
    install_command = 'gem install ' + gem_name
    
    # install missing gem
    system(install_command)
    
    # retry
    Gem.clear_paths
    puts 'Trying again ...'
    require gem_name
    retry
end
#Install my gems and require them
installing_missing_gems do
    require 'httparty'
    require 'json'
end
#Define variables to be used in the script
#Api url
apiUrl = 'https://api.magicthegathering.io/'
#Segment of the api
apiSegement = 'v1/cards?'
#Params to start the script with
apiInitialParameters = 'pageSize=10'
#Location of the card schema
#cardSchemaUrl = 'https://raw.githubusercontent.com/ethnp/mtg_schema/master/card_schema.json'
#To hold  all cards in a batch
cardsObj = Array[]
#Get the schema for the cards database
#cardApi = HTTParty.get(cardSchemaUrl)
#print cardSchema.parsed_response
#cardObj = OpenStruct.new
#cardObj.card = JSON.parse(cardApi.body, object_class: OpenStruct)
#Set the cardObj to the schema. This abstraction is needed for resetting the variable in the loop below.
#cardObj = cardSchema
cardCnt = 0
#Call the mtg api for cards
apiResponse = JSON.parse(HTTParty.get(apiUrl + apiSegement + apiInitialParameters).body, object_class: OpenStruct)
#apiObj = JSON.parse(apiResponse.body, object_class: OpenStruct)
#print response.code
#print response.parsed_response
#print JSON.pretty_generate(response.parsed_response)
#print JSON.pretty_generate(apiResponse.headers['total-count'].to_i)
#while x >= response.headers['total-count'].to_i
#print apiResponse
#Loopthrough the api response for the mtg data
apiResponse.to_h.each do |parent, cards|
    #Loop through each card and add the metadata to the schema
    cards.each do |card|
        cardsObj << {
            "id": card.id,
            "name": card.name,
            "manaCost": card.manaCost,
            "colors": card.colors,
            "colorIdentity": card.colorIdentity,
            "type": card.type,
            "supertypes": card.supertypes,
            "types": card.types,
            "subtypes": card.subtypes,
            "rarity": card.rarity,
            "set": card.set,
            "setName": card.setName,
            "text": card.text,
            "artist": card.artist,
            "number": card.number,
            "power": card.power,
            "toughness": card.toughness,
            "layout": card.layout,
            "multiverseid": card.multiverseid,
            "imageUrl": card.imageUrl,
            "variations": card.variations,
            "rulings": card.rulings,
            "printings": card.printings,
            "originalText": card.originalText,
            "originalType": card.originalType,
            "legalities": card.legalities
        }
    end
end

cardsObj.each do |cards|
    cards.to_h.each do |k,v|
        #if (k.to_s == "name" || k.to_s == "manaCost" || k.to_s == "rarity" || k.to_s == "setName")
            puts "#{k} => #{v}"
        #end
    end
    puts "\n"
end