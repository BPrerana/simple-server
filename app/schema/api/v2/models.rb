class Api::V2::Models < Api::Current::Models
  class << self
    def nested_patient
      patient.deep_merge(
        properties: {
          address: { '$ref' => '#/definitions/address' },
          phone_numbers: { '$ref' => '#/definitions/phone_numbers' } },
        description: 'Patient with address and phone numbers nested.',
      )
    end

    def definitions
      super.except(
        :patient_business_identifier,
        :patient_business_identifiers,
      )
    end
  end
end
