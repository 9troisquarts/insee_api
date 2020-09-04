module InseeApi

  class Siren
    attr_reader :client

    SIREN_ROOT_URL = "/entreprises/sirene/V3"

    # Rechercher une unité légale dans la base siren
    # Permet de faire une recherche par
    # raison sociale => name : Obligatoire
    # code postal => postcode
    # active => Uniquement les établissement actif/fermé/indifférent (true/false/nil)
    # date => Uniquement les établiseement actif a la date renseignée
    def self.search(search: {}, client: nil)
      raise "Search must be a valid hash" unless search.is_a?(Hash)
      name = search[:name].gsub(" ", "-")
      return nil unless name.is_a?(String) && name.size > 0

      client = client || InseeApi::Client.new

      query = "raisonSociale:#{name}"
      query += " AND codePostalEtablissement:#{search[:postcode]}" if search[:postcode]
      query += " AND periode(etatAdministratifEtablissement:#{search[:active] ? 'A' : 'F'})" unless search[:active].nil?
      data = {
        q: query
      }
      data[:date] = search[:date] || Date.today
      response = client.send_request(SIREN_ROOT_URL + "/siret", data: data)

      return [] unless response["etablissements"] && response["etablissements"].is_a?(Array) && response["etablissements"].size > 0
      response["etablissements"].map{ |etablissement_json| InseeApi::LegalUnit.new(etablissement_json) }
    end
  end

end
