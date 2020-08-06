BEGIN;
--
-- Create model ANNOTATION
--
CREATE TABLE "main_model_annotation" ("annotation_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "comment" varchar(150) NOT NULL, "verdict" integer NOT NULL, "observed_min_wave_height" real NOT NULL, "observed_max_wave_height" real NOT NULL);
--
-- Create model BEACH
--
CREATE TABLE "main_model_beach" ("beach_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(45) NOT NULL, "time_impact" integer NOT NULL, "min_reccomended_skill_level" integer NOT NULL, "latitude" real NOT NULL, "longitude" real NOT NULL);
--
-- Create model BEACH_BUOYS
--
CREATE TABLE "main_model_beach_buoys" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"));
--
-- Create model BUOY_READING
--
CREATE TABLE "main_model_buoy_reading" ("buoy_reading_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(45) NOT NULL, "sig_wave_height" real NOT NULL, "peak_period" integer NOT NULL, "mean_wave_direction_degree" integer NOT NULL);
--
-- Create model LIGHTING
--
CREATE TABLE "main_model_lighting" ("lighting_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "first_light" time NOT NULL, "last_light" time NOT NULL, "sunrise" time NOT NULL, "sunset" time NOT NULL, "date" date NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"));
--
-- Create model READING_INCREMENT
--
CREATE TABLE "main_model_reading_increment" ("reading_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "time" time NOT NULL);
--
-- Create model REGION
--
CREATE TABLE "main_model_region" ("region_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(45) NOT NULL);
--
-- Create model SURFER
--
CREATE TABLE "main_model_surfer" ("surfer_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "first_name" varchar(45) NOT NULL, "last_name" varchar(45) NOT NULL, "skill_level" integer NOT NULL, "favorite_beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "local_region_id" integer NOT NULL REFERENCES "main_model_region" ("region_id"));
--
-- Create model SURFLINE_REPORT
--
CREATE TABLE "main_model_surfline_report" ("report_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "min_wave_height" real NOT NULL, "max_wave_height" real NOT NULL, "verdict" integer NOT NULL, "beach_id" integer NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"), "region_id" integer NULL REFERENCES "main_model_region" ("region_id"));
--
-- Create model SWELL
--
CREATE TABLE "main_model_swell" ("swell_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "height" real NOT NULL, "period" integer NOT NULL, "direction" varchar(3) NOT NULL, "degree" integer NOT NULL, "growth_direction" integer NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "buoy_reading_id" integer NULL REFERENCES "main_model_buoy_reading" ("buoy_reading_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"));
--
-- Create model TIDE
--
CREATE TABLE "main_model_tide" ("tide_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "height" real NOT NULL, "label" varchar(10) NOT NULL, "growth_direction" integer NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"));
--
-- Create model WEATHER
--
CREATE TABLE "main_model_weather" ("weather_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "temperature" integer NOT NULL, "sky_condition" varchar(15) NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"));
--
-- Create model WETSUIT
--
CREATE TABLE "main_model_wetsuit" ("wetsuit_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "thickness" varchar(3) NOT NULL, "model" varchar(25) NOT NULL, "brand" varchar(25) NOT NULL);
--
-- Create model WIND
--
CREATE TABLE "main_model_wind" ("wind_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "speed" real NOT NULL, "direction" varchar(3) NOT NULL, "degree" integer NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"));
--
-- Add field wetsuit to surfline_report
--
ALTER TABLE "main_model_surfline_report" RENAME TO "main_model_surfline_report__old";
CREATE TABLE "main_model_surfline_report" ("report_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "min_wave_height" real NOT NULL, "max_wave_height" real NOT NULL, "verdict" integer NOT NULL, "beach_id" integer NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"), "region_id" integer NULL REFERENCES "main_model_region" ("region_id"), "wetsuit_id" integer NULL REFERENCES "main_model_wetsuit" ("wetsuit_id"));
INSERT INTO "main_model_surfline_report" ("min_wave_height", "region_id", "max_wave_height", "reading_increment_id", "beach_id", "verdict", "wetsuit_id", "report_id") SELECT "min_wave_height", "region_id", "max_wave_height", "reading_increment_id", "beach_id", "verdict", NULL, "report_id" FROM "main_model_surfline_report__old";
DROP TABLE "main_model_surfline_report__old";
CREATE INDEX "main_model_beach_buoys_beach_id_690d5365" ON "main_model_beach_buoys" ("beach_id");
CREATE INDEX "main_model_lighting_beach_id_90eaa9d9" ON "main_model_lighting" ("beach_id");
CREATE INDEX "main_model_surfer_favorite_beach_id_966f480c" ON "main_model_surfer" ("favorite_beach_id");
CREATE INDEX "main_model_surfer_local_region_id_1f676d67" ON "main_model_surfer" ("local_region_id");
CREATE INDEX "main_model_swell_beach_id_09229675" ON "main_model_swell" ("beach_id");
CREATE INDEX "main_model_swell_buoy_reading_id_f2776608" ON "main_model_swell" ("buoy_reading_id");
CREATE INDEX "main_model_swell_reading_increment_id_85174ddc" ON "main_model_swell" ("reading_increment_id");
CREATE INDEX "main_model_tide_beach_id_377c00b1" ON "main_model_tide" ("beach_id");
CREATE INDEX "main_model_tide_reading_increment_id_e0d55696" ON "main_model_tide" ("reading_increment_id");
CREATE INDEX "main_model_weather_beach_id_6dd6478e" ON "main_model_weather" ("beach_id");
CREATE INDEX "main_model_weather_reading_increment_id_43fe380a" ON "main_model_weather" ("reading_increment_id");
CREATE INDEX "main_model_wind_beach_id_c5749660" ON "main_model_wind" ("beach_id");
CREATE INDEX "main_model_wind_reading_increment_id_b76ed93e" ON "main_model_wind" ("reading_increment_id");
CREATE INDEX "main_model_surfline_report_beach_id_3dd8e9ff" ON "main_model_surfline_report" ("beach_id");
CREATE INDEX "main_model_surfline_report_reading_increment_id_f09a9a4e" ON "main_model_surfline_report" ("reading_increment_id");
CREATE INDEX "main_model_surfline_report_region_id_540396a9" ON "main_model_surfline_report" ("region_id");
CREATE INDEX "main_model_surfline_report_wetsuit_id_9287d6ef" ON "main_model_surfline_report" ("wetsuit_id");
--
-- Add field reading_increment to buoy_reading
--
ALTER TABLE "main_model_buoy_reading" RENAME TO "main_model_buoy_reading__old";
CREATE TABLE "main_model_buoy_reading" ("buoy_reading_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(45) NOT NULL, "sig_wave_height" real NOT NULL, "peak_period" integer NOT NULL, "mean_wave_direction_degree" integer NOT NULL, "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"));
INSERT INTO "main_model_buoy_reading" ("name", "mean_wave_direction_degree", "reading_increment_id", "sig_wave_height", "peak_period", "buoy_reading_id") SELECT "name", "mean_wave_direction_degree", NULL, "sig_wave_height", "peak_period", "buoy_reading_id" FROM "main_model_buoy_reading__old";
DROP TABLE "main_model_buoy_reading__old";
CREATE INDEX "main_model_buoy_reading_reading_increment_id_8029f591" ON "main_model_buoy_reading" ("reading_increment_id");
--
-- Add field buoy_reading to beach_buoys
--
ALTER TABLE "main_model_beach_buoys" RENAME TO "main_model_beach_buoys__old";
CREATE TABLE "main_model_beach_buoys" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "buoy_reading_id" integer NOT NULL REFERENCES "main_model_buoy_reading" ("buoy_reading_id"));
INSERT INTO "main_model_beach_buoys" ("beach_id", "id", "buoy_reading_id") SELECT "beach_id", "id", NULL FROM "main_model_beach_buoys__old";
DROP TABLE "main_model_beach_buoys__old";
CREATE INDEX "main_model_beach_buoys_beach_id_690d5365" ON "main_model_beach_buoys" ("beach_id");
CREATE INDEX "main_model_beach_buoys_buoy_reading_id_e858341c" ON "main_model_beach_buoys" ("buoy_reading_id");
--
-- Add field region to beach
--
ALTER TABLE "main_model_beach" RENAME TO "main_model_beach__old";
CREATE TABLE "main_model_beach" ("beach_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(45) NOT NULL, "time_impact" integer NOT NULL, "min_reccomended_skill_level" integer NOT NULL, "latitude" real NOT NULL, "longitude" real NOT NULL, "region_id" integer NOT NULL REFERENCES "main_model_region" ("region_id"));
INSERT INTO "main_model_beach" ("min_reccomended_skill_level", "region_id", "name", "longitude", "beach_id", "latitude", "time_impact") SELECT "min_reccomended_skill_level", NULL, "name", "longitude", "beach_id", "latitude", "time_impact" FROM "main_model_beach__old";
DROP TABLE "main_model_beach__old";
CREATE INDEX "main_model_beach_region_id_3561722a" ON "main_model_beach" ("region_id");
--
-- Add field beach to annotation
--
ALTER TABLE "main_model_annotation" RENAME TO "main_model_annotation__old";
CREATE TABLE "main_model_annotation" ("annotation_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "comment" varchar(150) NOT NULL, "verdict" integer NOT NULL, "observed_min_wave_height" real NOT NULL, "observed_max_wave_height" real NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"));
INSERT INTO "main_model_annotation" ("comment", "observed_max_wave_height", "beach_id", "observed_min_wave_height", "verdict", "annotation_id") SELECT "comment", "observed_max_wave_height", NULL, "observed_min_wave_height", "verdict", "annotation_id" FROM "main_model_annotation__old";
DROP TABLE "main_model_annotation__old";
CREATE INDEX "main_model_annotation_beach_id_9e94b59e" ON "main_model_annotation" ("beach_id");
--
-- Add field reading_increment to annotation
--
ALTER TABLE "main_model_annotation" RENAME TO "main_model_annotation__old";
CREATE TABLE "main_model_annotation" ("annotation_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "comment" varchar(150) NOT NULL, "verdict" integer NOT NULL, "observed_min_wave_height" real NOT NULL, "observed_max_wave_height" real NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"));
INSERT INTO "main_model_annotation" ("comment", "observed_max_wave_height", "reading_increment_id", "beach_id", "observed_min_wave_height", "verdict", "annotation_id") SELECT "comment", "observed_max_wave_height", NULL, "beach_id", "observed_min_wave_height", "verdict", "annotation_id" FROM "main_model_annotation__old";
DROP TABLE "main_model_annotation__old";
CREATE INDEX "main_model_annotation_beach_id_9e94b59e" ON "main_model_annotation" ("beach_id");
CREATE INDEX "main_model_annotation_reading_increment_id_882298e1" ON "main_model_annotation" ("reading_increment_id");
--
-- Add field surfer to annotation
--
ALTER TABLE "main_model_annotation" RENAME TO "main_model_annotation__old";
CREATE TABLE "main_model_annotation" ("annotation_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "comment" varchar(150) NOT NULL, "verdict" integer NOT NULL, "observed_min_wave_height" real NOT NULL, "observed_max_wave_height" real NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"), "surfer_id" integer NOT NULL REFERENCES "main_model_surfer" ("surfer_id"));
INSERT INTO "main_model_annotation" ("comment", "surfer_id", "observed_max_wave_height", "reading_increment_id", "beach_id", "observed_min_wave_height", "verdict", "annotation_id") SELECT "comment", NULL, "observed_max_wave_height", "reading_increment_id", "beach_id", "observed_min_wave_height", "verdict", "annotation_id" FROM "main_model_annotation__old";
DROP TABLE "main_model_annotation__old";
CREATE INDEX "main_model_annotation_beach_id_9e94b59e" ON "main_model_annotation" ("beach_id");
CREATE INDEX "main_model_annotation_reading_increment_id_882298e1" ON "main_model_annotation" ("reading_increment_id");
CREATE INDEX "main_model_annotation_surfer_id_3166794f" ON "main_model_annotation" ("surfer_id");
--
-- Add field surfline_report to annotation
--
ALTER TABLE "main_model_annotation" RENAME TO "main_model_annotation__old";
CREATE TABLE "main_model_annotation" ("annotation_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "comment" varchar(150) NOT NULL, "verdict" integer NOT NULL, "observed_min_wave_height" real NOT NULL, "observed_max_wave_height" real NOT NULL, "beach_id" integer NOT NULL REFERENCES "main_model_beach" ("beach_id"), "reading_increment_id" integer NOT NULL REFERENCES "main_model_reading_increment" ("reading_id"), "surfer_id" integer NOT NULL REFERENCES "main_model_surfer" ("surfer_id"), "surfline_report_id" integer NULL REFERENCES "main_model_surfline_report" ("report_id"));
INSERT INTO "main_model_annotation" ("comment", "surfer_id", "observed_max_wave_height", "reading_increment_id", "surfline_report_id", "beach_id", "observed_min_wave_height", "verdict", "annotation_id") SELECT "comment", "surfer_id", "observed_max_wave_height", "reading_increment_id", NULL, "beach_id", "observed_min_wave_height", "verdict", "annotation_id" FROM "main_model_annotation__old";
DROP TABLE "main_model_annotation__old";
CREATE INDEX "main_model_annotation_beach_id_9e94b59e" ON "main_model_annotation" ("beach_id");
CREATE INDEX "main_model_annotation_reading_increment_id_882298e1" ON "main_model_annotation" ("reading_increment_id");
CREATE INDEX "main_model_annotation_surfer_id_3166794f" ON "main_model_annotation" ("surfer_id");
CREATE INDEX "main_model_annotation_surfline_report_id_cdac2ee8" ON "main_model_annotation" ("surfline_report_id");
COMMIT;
