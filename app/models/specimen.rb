class Specimen < GraphStarter::Asset
  has_images

  property :minimum_depth_in_meters
  property :record_type
  property :mineral_complex
  property :verbatim_latitude
  property :month
  property :continent
  property :member
  property :collection_name
  property :occurrence_id
  property :family
  property :latest_epoch_or_highest_series
  property :texture
  property :recovery_weight
  property :maximum_depth_in_meters
  property :water_body
  property :determinations
  property :meteorite_group
  property :dqi
  property :kingdom
  property :decimal_latitude
  property :earliest_era_or_lowest_erathem
  property :identification_as_registered
  property :infraspecific_epithet
  property :plant_description
  property :lithostratigraphy
  property :latest_era_or_highest_erathem
  property :record_number
  property :day
  property :individual_count
  property :life_stage
  property :chondrite_achondrite
  property :vice_county
  property :scientific_name
  property :exsiccati
  property :tectonic_province
  property :lowest_biostratigraphic_zone
  property :occurrence
  property :habitat
  property :set_mark
  property :sex
  property :year
  property :chronostratigraphy
  property :event_time
  property :part_type
  property :latest_eon_or_highest_eonothem
  property :other_catalog_numbers
  property :latest_period_or_highest_system
  property :exsiccati_number
  property :centroid
  property :kind_of_collection
  property :specific_epithet
  property :date_registered
  property :identification_other
  property :geodetic_datum
  property :barcode
  property :collection_code
  property :higher_geography
  property :latest_age_or_highest_stage
  property :formation
  property :earliest_epoch_or_lowest_series
  property :group
  property :highest_biostratigraphic_zone
  property :petrology_type
  property :earliest_age_or_lowest_stage
  property :created
  property :meteorite_type
  property :decimal_longitude
  property :nest_shape
  property :relationship_of_resource
  property :genus
  property :preparation_type
  property :clutch_size
  property :associated_media
  property :phylum
  property :sub_department
  property :cultivated
  property :host_rock
  property :kind_of_object
  property :higher_classification
  property :age_type
  property :island_group
  property :identification_description
  property :resuspended_in
  property :catalog_number
  property :verbatim_longitude
  property :nest_site
  property :mining_district
  property :preparations
  property :identification_qualifier
  property :maximum_elevation_in_meters
  property :related_resource_id
  property :earliest_eon_or_lowest_eonothem
  property :modified
  property :bed
  property :island
  property :minimum_elevation_in_meters
  property :total_volume
  property :max_error
  property :geology_region
  property :subgenus
  property :petrology_subtype
  property :expedition
  property :institution_code
  property :identified_by
  property :earliest_period_or_lowest_system
  property :preservative
  property :georeference_protocol
  property :recovery
  property :registered_weight
  property :population_code
  property :taxon_rank
  property :catalogue_description
  property :deposit_type
  property :recovery_date
  property :registered_weight_unit
  property :type_status
  property :scientific_name_authorship
  property :nhm_class
  property :collection_kind
  property :commodity
  property :age
  property :basis_of_record
  property :date_identified
  property :observed_weight
  property :registration_code
  property :recorded_by
  property :_id, index: :exact
  property :extraction_method
  property :order
  property :meteorite_class
  property :label_locality

  has_one :in, :donor, type: :DONATED, model_class: :Person
  has_one :out, :country, type: :FROM_COUNTRY
  has_one :out, :mine, type: :FROM_MINE
  has_one :out, :state_province, type: :FROM_STATE_PROVINCE
  has_one :out, :identification_variety, type: :HAS_IDENTIFICATION_VARIETY
  has_one :out, :locality, type: :FROM_LOCALITY
  has_one :out, :collection, type: :IN_COLLECTION
  has_one :out, :sub_department, type: :IN_SUB_DEPARTMENT

  self.category_association = :sub_department
end

