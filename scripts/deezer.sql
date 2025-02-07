CREATE TABLE artist(id BIGINT PRIMARY KEY, "name" VARCHAR, link VARCHAR, share VARCHAR, picture VARCHAR, picture_small VARCHAR, picture_medium VARCHAR, picture_big VARCHAR, picture_xl VARCHAR, nb_album BIGINT, nb_fan BIGINT, radio BOOLEAN,  tracklist VARCHAR, "type" VARCHAR);

CREATE TABLE track(id BIGINT PRIMARY KEY, readable BOOLEAN, title VARCHAR, title_short VARCHAR, title_version VARCHAR, isrc VARCHAR, link VARCHAR, duration BIGINT, rank BIGINT, explicit_lyrics BOOLEAN, explicit_content_lyrics BIGINT, explicit_content_cover BIGINT, preview VARCHAR, md5_image VARCHAR, time_add BIGINT, "type" VARCHAR, album_id BIGINT, artist_id BIGINT);

CREATE TABLE album(id BIGINT PRIMARY KEY, title VARCHAR, artist_id BIGINT, upc VARCHAR, cover VARCHAR, cover_small VARCHAR, cover_medium VARCHAR, cover_big VARCHAR, cover_xl VARCHAR, md5_image VARCHAR, genre_id BIGINT, fans BIGINT, release_date DATE, record_type VARCHAR, tracklist VARCHAR, explicit_lyrics BOOLEAN, "type" VARCHAR);
-- CREATE UNIQUE INDEX album_id_idx ON album(id);

CREATE TABLE playlist(id BIGINT PRIMARY KEY, title VARCHAR, duration BIGINT, public BOOLEAN, is_loved_track BOOLEAN, collaborative BOOLEAN, nb_tracks BIGINT, fans BIGINT, link VARCHAR, picture VARCHAR, picture_small VARCHAR, picture_medium VARCHAR, picture_big VARCHAR, picture_xl VARCHAR, checksum UUID, tracklist VARCHAR, creation_date TIMESTAMP, md5_image VARCHAR, picture_type VARCHAR, time_add BIGINT, time_mod BIGINT, creator STRUCT(id BIGINT, "name" VARCHAR, tracklist VARCHAR, "type" VARCHAR), "type" VARCHAR);
-- CREATE UNIQUE INDEX playlist_id_idx ON playlist(id);
