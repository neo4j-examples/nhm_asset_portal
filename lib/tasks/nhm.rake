require 'open-uri'

namespace :nhm do
  CACHE = ActiveSupport::Cache::FileStore.new('./cache')

  def get_page(page_number, page_size = 500)
    offset = page_size * (page_number - 1)
    resource_id = '05ff2255-c38a-40c9-b657-4ccb55ab2feb'
    url = "http://data.nhm.ac.uk/api/action/datastore_search?resource_id=#{resource_id}&q=jones&limit=#{page_size}&offset=#{offset}"
    CACHE.fetch([resource_id, page_size, offset].join('-'), expires_in: 10.years) do
      JSON.parse(open(url).read)
    end
  end

  task get_dynamic_fields: :environment do
    fields = []
    CSV.open(Rails.root.join('db/occurrence.csv')).each do |row|
      next if row[2] == 'dynamicProperties'
      fields += JSON.parse(row[2]).keys
      fields.uniq!
      putc '.'
    end

    puts fields.sort
  end

  DYNAMIC_FIELDS = %w(
    age_type
    catalogue_description
    chondrite_achondrite
    chronostratigraphy
    clutch_size
    collection_kind
    collection_name
    date_registered
    deposit_type
    donor_name
    exsiccati_number
    extraction_method
    geology_region
    host_rock
    identification_as_registered
    identification_description
    identification_other
    identification_variety
    kind_of_collection
    kind_of_object
    label_locality
    max_error
    meteorite_class
    meteorite_group
    meteorite_type
    mineral_complex
    mining_district
    nest_shape
    nest_site
    observed_weight
    part_type
    petrology_subtype
    petrology_type
    plant_description
    population_code
    preparation_type
    record_type
    recovery_date
    recovery_weight
    registered_weight
    registered_weight_unit
    registration_code
    related_resource_id
    relationship_of_resource
    resuspended_in
    set_mark
    sub_department
    tectonic_province
    total_volume
    vice_county
  )
  task import: :environment do
    Neo4j::Session.query("MATCH n OPTIONAL MATCH n-[r]-() DELETE n, r")

    # Mentioning models so that constraints get created
    # See: https://github.com/neo4jrb/neo4j/issues/991
    Specimen
    Locality
    StateProvince
    SubDepartment

    #  records.each do |record|
    CSV.open(Rails.root.join('db/occurrence.csv'), headers: true).each do |row|
      putc '.'
      record = row.to_hash
      record.merge!(JSON.parse(record.delete('dynamicProperties')))
      DYNAMIC_FIELDS.each do |field|
        record[field] = record.delete(field.delete('_'))
      end
      record['determinations'] = record.delete('determinations').inspect

      record.transform_keys!(&:underscore)
      record['nhm_class'] = record.delete('class')
      record.reject! {|_, v| v.nil? }

      association_fields = %w(donor_name country mine sub_department state_province identification_variety locality collection).each_with_object({}) do |field, fields|
        fields[field] = record.delete(field)
      end

      specimen = Specimen.new(record)
      specimen.title = record['catalog_number']
      specimen.private = false
      specimen.save

      [
        [:donor, Person, 'donor_name'],
        [:country, Country, 'country'],
        [:mine, Mine, 'mine'],
        [:sub_department, SubDepartment, 'sub_department'],
        [:state_province, StateProvince, 'state_province'],
        [:identification_variety, IdentificationVariety, 'identification_variety'],
        [:locality, Locality, 'locality'],
      ].each do |association, model_class, field|
        if association_fields[field].present?
          association_object = model_class.merge(title: association_fields[field])
          specimen.send("#{association}=", association_object)
        end
      end

      if association_fields['collection'].present?
        specimen.collection = Collection.merge(title: association_fields['collection'], code: association_fields['collection'])
      end

      if association_fields['state_province'].present? && specimen.country
        association_object = Neo4j::Session.current.query("MERGE (c:Country:Asset {title: {country_title}}) WITH c MERGE c<-[:IN_COUNTRY]-(sp:StateProvince:Asset {title: {state_province_title}}) RETURN sp", country_title: specimen.country.title, state_province_title: association_fields['state_province']).first.sp
        specimen.state_province = association_object
      end

      if association_fields['locality'].present? && specimen.state_province
        association_object = Neo4j::Session.current.query("MERGE (sp:StateProvince:Asset {title: {state_province_title}}) WITH sp MERGE sp<-[:IN_STATE_PROVINCE]-(loc:Locality:Asset {title: {locality_title}}) RETURN loc", state_province_title: specimen.state_province.title, locality_title: association_fields['locality']).first.loc
        specimen.locality = association_object
      end

    end
  end

  task import_images: :environment do
    CSV.open(Rails.root.join('db/multimedia.csv'), headers: true).each do |row|
      specimen = Specimen.find_by(_id: row['_id'])

      if !specimen.images.find_by(original_url: row['identifier'])
        begin
          image = ::GraphStarter::Image.create(source: row['identifier'], original_url: row['identifier'], title: row['title'], details: row.to_hash)
        rescue OpenURI::HTTPError
          nil
        end
        specimen.images << image
        putc '+'
      else
        putc '.'
      end
    end
  end
end
