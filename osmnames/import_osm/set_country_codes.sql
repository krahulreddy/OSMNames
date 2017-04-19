DROP FUNCTION IF EXISTS set_country_code_for_containing_entities(VARCHAR(2), geometry);
CREATE FUNCTION set_country_code_for_containing_entities(country_code_in VARCHAR(2), geometry_value GEOMETRY) RETURNS VOID AS $$
BEGIN
  UPDATE osm_linestring SET country_code = country_code_in WHERE country_code = '' IS NOT FALSE
                                                                 AND st_contains(geometry_value, geometry);

  UPDATE osm_point SET country_code = country_code_in WHERE country_code = '' IS NOT FALSE
                                                            AND st_contains(geometry_value, geometry);

  UPDATE osm_polygon SET country_code = country_code_in WHERE country_code = '' IS NOT FALSE
                                                              AND st_contains(geometry_value, geometry);

  UPDATE osm_housenumber SET country_code = country_code_in WHERE country_code = '' IS NOT FALSE
                                                                  AND st_contains(geometry_value, geometry);
END;
$$ LANGUAGE plpgsql;


DO $$
BEGIN
  PERFORM set_country_code_for_containing_entities(lower(country_code), geometry)
          FROM country_osm_grid
          ORDER BY area ASC;
END
$$ LANGUAGE plpgsql;