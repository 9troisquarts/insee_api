module InseeApi
  class LegalUnit
    attr_reader :name, :siren, :siret, :address_1, :address_2, :postcode, :city, :naf

    LEGAL_UNIT_ATTRIBUTES = {
      siren: "siren",
      siret: "siret",
    }

    def initialize(json_legal_unit)
      if json_legal_unit
        if json_legal_unit["uniteLegale"]
          @name = json_legal_unit["uniteLegale"]["denominationUniteLegale"]
          @naf = json_legal_unit["uniteLegale"]["activitePrincipaleUniteLegale"]
        end
        @siren = json_legal_unit["siren"]
        @siret = json_legal_unit["siret"]
        if json_legal_unit["adresseEtablissement"]
          json_address = json_legal_unit["adresseEtablissement"]
          @address_1 = [json_address["numeroVoieEtablissement"], json_address["typeVoieEtablissement"], json_address["libelleVoieEtablissement"]].reject(&:nil?).join(" ")
          @address_2 = json_address["complementAdresseEtablissement"]
          @postcode = json_address["codePostalEtablissement"]
          @city = json_address["libelleCommuneEtablissement"]
        end
      end
    end

    def address
      {
        address_1: @address_1,
        address_2: @address_2,
        postcode: @postcode,
        city: @city
      }
    end



  end
end