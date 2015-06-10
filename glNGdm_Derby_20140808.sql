-- Copyright 2013 N. P. Maling
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

DROP SCHEMA glngdb;

CREATE SCHEMA glngdb;

DROP TABLE glngdb.activity;

CREATE TABLE glngdb.activity (
  activityid INT NOT NULL,
  projectid INT NOT NULL,
  researcherid INT NOT NULL,
  scheddate DATE NOT NULL,
  completedate DATE NOT NULL,
  typecode CHAR(1) NOT NULL,
  status VARCHAR(16) NOT NULL,
  description VARCHAR(32672) NOT NULL,
  priority VARCHAR(16) NOT NULL,
  comments VARCHAR(32672) NOT NULL,
  PRIMARY KEY (activityid)
);

CREATE INDEX activity_project_idx ON glngdb.activity (projectid ASC);

CREATE INDEX activity_researcher_idx ON glngdb.activity (researcherid ASC);

DROP TABLE glngdb.persona;

CREATE TABLE glngdb.persona (
  perid INT NOT NULL,
  personaid INT NOT NULL,
  personanum INT NOT NULL,
  persona_name VARCHAR(128) NOT NULL,
  description_comments VARCHAR(32672) NOT NULL,
  PRIMARY KEY (perid)
);

CREATE INDEX personanameidx ON glngdb.persona (persona_name ASC);

DROP TABLE glngdb.place;

CREATE TABLE glngdb.place (
  placeid INT NOT NULL,
  startdate VARCHAR(96) NOT NULL,
  enddate VARCHAR(96) NOT NULL,
  ascdescnone CHAR(1) NOT NULL,
  placecomment VARCHAR(32672) NOT NULL,
  PRIMARY KEY (placeid)
);

CREATE INDEX plstartdate ON glngdb.place (startdate ASC);

CREATE INDEX plenddate ON glngdb.place (enddate ASC);

DROP TABLE glngdb.placeparttype;

CREATE TABLE glngdb.placeparttype (
  placeparttypeid INT NOT NULL,
  pptname VARCHAR(32) NOT NULL,
  PRIMARY KEY (placeparttypeid)
);

DROP TABLE glngdb.placepart;

CREATE TABLE glngdb.placepart (
  placepartid INT NOT NULL,
  placeid INT NOT NULL,
  placeparttypeid INT NOT NULL,
  name VARCHAR(128) NOT NULL,
  sequencenumber INT NOT NULL,
  PRIMARY KEY (placepartid),
  FOREIGN KEY (PLACEPARTTYPEID) REFERENCES glngdb.PLACEPARTTYPE (PLACEPARTTYPEID),
  FOREIGN KEY (PLACEID) REFERENCES glngdb.PLACE (PLACEID)
);

DROP TABLE glngdb.characteristic;

CREATE TABLE glngdb.characteristic (
  characteristicid INT NOT NULL,
  placeid INT NOT NULL,
  characteristicdate VARCHAR(96) NOT NULL,
  ascdescnone CHAR(1) NOT NULL,
  PRIMARY KEY (characteristicid),
  FOREIGN KEY (placeid) REFERENCES glngdb.PLACE (PLACEID)
);

DROP TABLE glngdb.charparttype;

-- GEDCOMTAG in this table is not in the GDM and is only here to accommodate
-- that standard and provide some future consistency with imports/exports
CREATE TABLE glngdb.charparttype (
  charparttypeid INT NOT NULL,
  charparttypename VARCHAR(32) NOT NULL,
  gedcomtag VARCHAR(4) NOT NULL,
  PRIMARY KEY (charparttypeid)
);

DROP TABLE glngdb.charpart;

CREATE TABLE glngdb.charpart (
  characteristicpartid INT NOT NULL,
  characteristicid INT NOT NULL,
  charparttypeid INT NOT NULL,
  charpartname VARCHAR(32) NOT NULL,
  charpartseq INT NOT NULL,
  PRIMARY KEY (characteristicpartid),
  FOREIGN KEY (CHARACTERISTICID) REFERENCES glngdb.CHARACTERISTIC (CHARACTERISTICID),
  FOREIGN KEY (CHARPARTTYPEID) REFERENCES glngdb.CHARPARTTYPE (CHARPARTTYPEID)
);

DROP TABLE glngdb.project;

CREATE TABLE glngdb.project (
  projectid INT NOT NULL,
  name VARCHAR(128) NOT NULL,
  projectdesc VARCHAR(16384) NOT NULL,
  clientdata VARCHAR(16384) NOT NULL,
  PRIMARY KEY (projectid)
);

DROP TABLE glngdb.repository;

CREATE TABLE glngdb.repository (
  repositoryid INT NOT NULL,
  placeid INT NOT NULL,
  reponame VARCHAR(128) NOT NULL,
  comments VARCHAR(16384) NOT NULL,
  PRIMARY KEY (repositoryid),
  FOREIGN KEY (PLACEID) REFERENCES glngdb.PLACE (PLACEID)
);

DROP TABLE glngdb.resobjective;

CREATE TABLE glngdb.resobjective (
  resobjid INT NOT NULL,
  projectid INT NOT NULL,
  subjectid INT NOT NULL,
  subjecttype CHAR(1) NOT NULL,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(16384) NOT NULL,
  sequencenumber INT NOT NULL,
  priority VARCHAR(16) NOT NULL,
  status VARCHAR(16) NOT NULL,
  PRIMARY KEY (resobjid),
  FOREIGN KEY (PROJECTID) REFERENCES glngdb.PROJECT (PROJECTID)
);

DROP TABLE glngdb.resobjactivity;

CREATE TABLE glngdb.resobjactivity (
  resobjactivityid INT NOT NULL,
  resobjid INT NOT NULL,
  activityid INT NOT NULL,
  PRIMARY KEY (resobjactivityid),
  FOREIGN KEY (RESOBJID) REFERENCES glngdb.RESOBJECTIVE (RESOBJID),
  FOREIGN KEY (ACTIVITYID) REFERENCES glngdb.ACTIVITY (ACTIVITYID)
);

DROP TABLE glngdb.researcher;

CREATE TABLE glngdb.researcher (
  researcherid INT NOT NULL,
  name VARCHAR(128) NOT NULL,
  addressid INT NOT NULL,
  comments VARCHAR(16384) NOT NULL,
  PRIMARY KEY (researcherid)
);

DROP TABLE glngdb.resproj;

CREATE TABLE glngdb.resproj (
  resprojid INT NOT NULL,
  projectid INT NOT NULL,
  researcherid INT NOT NULL,
  rsearcherrole VARCHAR(32) NOT NULL,
  PRIMARY KEY (resprojid),
  FOREIGN KEY (RESEARCHERID) REFERENCES glngdb.RESEARCHER (RESEARCHERID),
  FOREIGN KEY (PROJECTID) REFERENCES glngdb.PROJECT (PROJECTID)
);

DROP TABLE glngdb.source;

CREATE TABLE glngdb.source (
  sourceid INT NOT NULL PRIMARY KEY,
  highersourceid INT NOT NULL,
  subjectplaceid INT NOT NULL,
  jurisplaceid INT NOT NULL,
  researcherid INT NOT NULL,
  subjectdate VARCHAR(96),
  comments VARCHAR(16384),
--  FOREIGN KEY (HIGHERSOURCEID) REFERENCES glngdb.SOURCE (HIGHERSOURCEID),
  FOREIGN KEY (SUBJECTPLACEID) REFERENCES glngdb.PLACE (PLACEID),
  FOREIGN KEY (JURISPLACEID) REFERENCES glngdb.PLACE (PLACEID),
  FOREIGN KEY (RESEARCHERID) REFERENCES glngdb.RESEARCHER (RESEARCHERID)
);

-- ALTER TABLE glngdb.SOURCE ADD CONSTRAINT HIGHSOURCE_FK FOREIGN KEY (HIGHERSOURCEID) REFERENCES glngdb.SOURCE (HIGHERSOURCEID);
-- ALTER TABLE glngdb.SOURCE ADD CONSTRAINT SUBJPLACE_FK FOREIGN KEY (SUBJECTPLACEID) REFERENCES glngdb.PLACE (PLACEID);
-- ALTER TABLE glngdb.SOURCE ADD CONSTRAINT JURISPLACE_FK FOREIGN KEY (JURISPLACEID) REFERENCES glngdb.PLACE (PLACEID);
-- ALTER TABLE glngdb.SOURCE ADD CONSTRAINT RESEARCHER_FK FOREIGN KEY (RESEARCHERID) REFERENCES glngdb.RESEARCHER (RESEARCHERID);


DROP TABLE glngdb.sourcegroup;

CREATE TABLE glngdb.sourcegroup (
  sourcegroupid INT NOT NULL,
  sourcegroupname VARCHAR(96),
  PRIMARY KEY (sourcegroupid)
);

DROP TABLE glngdb.srcgrpsrc;

CREATE TABLE glngdb.srcgrpsrc (
  srsgrpsrcid INT NOT NULL,
  sourceid INT NOT NULL,
  sourcegroupid INT NOT NULL,
  PRIMARY KEY (srsgrpsrcid),
  FOREIGN KEY (SOURCEID) REFERENCES glngdb.SOURCE (SOURCEID),
  FOREIGN KEY (SOURCEGROUPID) REFERENCES glngdb.SOURCEGROUP (SOURCEGROUPID)
);

DROP TABLE glngdb.citationparttype;

CREATE TABLE glngdb.citationparttype (
  citationparttypeid INT NOT NULL,
  citationparttypename VARCHAR(32) NOT NULL,
  PRIMARY KEY (citationparttypeid)
);

DROP TABLE glngdb.citationpart;

CREATE TABLE glngdb.citationpart (
  citationpartid INT NOT NULL,
  sourceid INT NOT NULL,
  citeparttypeid INT NOT NULL,
  citepartvalue VARCHAR(255) NOT NULL,
  PRIMARY KEY (citationpartid),
  FOREIGN KEY (SOURCEID) REFERENCES glngdb.SOURCE (SOURCEID),
  FOREIGN KEY (CITEPARTTYPEID) REFERENCES glngdb.CITATIONPARTTYPE (CITATIONPARTTYPEID)
);

DROP TABLE glngdb.suretyscheme;

CREATE TABLE glngdb.suretyscheme (
  suretyschemeid INT NOT NULL,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(16384) NOT NULL,
  PRIMARY KEY (suretyschemeid)
);

DROP TABLE glngdb.suretypart;

CREATE TABLE glngdb.suretypart (
  suretypartid INT NOT NULL,
  schemeid INT NOT NULL,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(32) NOT NULL,
  sequencenumber INT NOT NULL,
  PRIMARY KEY (suretypartid),
  FOREIGN KEY (SCHEMEID) REFERENCES glngdb.SURETYSCHEME (SURETYSCHEMEID)
);

CREATE INDEX spschemeidx ON glngdb.suretypart (schemeid ASC);

DROP TABLE glngdb.glassertion;

CREATE TABLE glngdb.glassertion (
  glassertionid INT NOT NULL,
  suretypartid INT NOT NULL,
  researcherid INT NOT NULL,
  sourceid INT NOT NULL,
  subject1id INT NOT NULL,
  subject1type CHAR(1) NOT NULL,
  subject2id INT NOT NULL, -- tableZ.per_no/tableZ.father/tableZ.mother ; Assertion.Subject2Type = 'P'
  subject2type CHAR(1) NOT NULL,
  value_role INT NOT NULL,
  disproved BOOLEAN,
  rationale VARCHAR(32672) NOT NULL,
  PRIMARY KEY (glassertionid),
  FOREIGN KEY (SURETYPARTID) REFERENCES glngdb.SURETYPART (SURETYPARTID),
  FOREIGN KEY (RESEARCHERID) REFERENCES glngdb.RESEARCHER (RESEARCHERID),
  FOREIGN KEY (SOURCEID) REFERENCES glngdb.SOURCE (SOURCEID)
);

DROP TABLE glngdb.assertassert;

CREATE TABLE glngdb.assertassert (
  assertassertid INT NOT NULL,
  idlo INT NOT NULL,
  idhi INT NOT NULL,
  seq INT NOT NULL,
  PRIMARY KEY (assertassertid),
  FOREIGN KEY (idlo) REFERENCES glngdb.GLASSERTION (GLASSERTIONID),
  FOREIGN KEY (idhi) REFERENCES glngdb.GLASSERTION (GLASSERTIONID)
);

-- BEGIN new table REPRESENTATION-MEDIA-TYPE (not in GDM)
-- - depended on by REPRESENTATION's reprmediaid FK
-- Holds the data GDM REPRESENTATION-TYPE would, but in a more accessible way
-- as user alterable/addable/updatable. Also contrary to TMG's internal enums
-- which were not modifiable
DROP TABLE glngdb.reprmediatype;

CREATE TABLE glngdb.reprmediatype (
  reprmediaid INT NOT NULL,
  reprmedianame VARCHAR(128) NOT NULL,
  PRIMARY KEY (reprmediaid)
);
-- END new table

DROP TABLE glngdb.representtype;

CREATE TABLE glngdb.representtype (
  reprtypeid INT NOT NULL,
  name VARCHAR(128) NOT NULL,
  PRIMARY KEY (reprtypeid)
);

DROP TABLE glngdb.representation;

CREATE TABLE glngdb.representation (
  representationid INT NOT NULL,
  sourceid INT NOT NULL,
  reprtypeid INT NOT NULL,
  reprmediaid INT NOT NULL,
  physfilecode VARCHAR(8192),
  comments VARCHAR(16384),
  externallink VARCHAR(255),
  PRIMARY KEY (representationid),
  FOREIGN KEY (SOURCEID) REFERENCES glngdb.SOURCE (SOURCEID),
  FOREIGN KEY (REPRTYPEID) REFERENCES glngdb.REPRESENTTYPE (REPRTYPEID),
  FOREIGN KEY (REPRMEDIAID) REFERENCES glngdb.REPRMEDIATYPE (REPRMEDIAID)
);

DROP TABLE glngdb.search;

CREATE TABLE glngdb.search (
  searchid INT NOT NULL,
  activityid INT NOT NULL, -- relates to glngdb.ACTIVITY
  sourceid INT NOT NULL,
  repositoryid INT NOT NULL,
  searchedfor VARCHAR(16384) NOT NULL,
  PRIMARY KEY (searchid),
  FOREIGN KEY (SOURCEID) REFERENCES glngdb.SOURCE (SOURCEID),
  FOREIGN KEY (REPOSITORYID) REFERENCES glngdb.REPOSITORY (REPOSITORYID)
);

DROP TABLE glngdb.eventtype;

-- GEDCOMTAG in this table is not in the GDM and is only here to accommodate
-- that standard and provide some future consistency with imports/exports
CREATE TABLE glngdb.eventtype (
  eventtypeid INT NOT NULL,
  eventtypename VARCHAR(32) NOT NULL,
  gedcomtag VARCHAR(4) NOT NULL,
  PRIMARY KEY (eventtypeid)
);

DROP TABLE glngdb.event;

CREATE TABLE glngdb.event (
  eventid INT NOT NULL,
  eventtypeid INT NOT NULL,
  placeid INT NOT NULL,
  eventdate VARCHAR(96) NOT NULL,
  eventname VARCHAR(128) NOT NULL,
  PRIMARY KEY (eventid),
  FOREIGN KEY (EVENTTYPEID) REFERENCES glngdb.EVENTTYPE (EVENTTYPEID),
  FOREIGN KEY (PLACEID) REFERENCES glngdb.PLACE (PLACEID)
);

DROP TABLE glngdb.eventtyperole;

CREATE TABLE glngdb.eventtyperole (
  eventtyperoleid INT NOT NULL,
  eventtypeid INT NOT NULL,
  eventtyperolename VARCHAR(32) NOT NULL,
  PRIMARY KEY (eventtyperoleid),
  FOREIGN KEY (EVENTTYPEID) REFERENCES glngdb.EVENTTYPE (EVENTTYPEID)
);

DROP TABLE glngdb.glgrouptype;

CREATE TABLE glngdb.glgrouptype (
  glgrouptypeid INT NOT NULL,
  glgroupname VARCHAR(32) NOT NULL,
  ascdescnone CHAR(1) NOT NULL,
  PRIMARY KEY (glgrouptypeid)
);

DROP TABLE glngdb.glgroup;

CREATE TABLE glngdb.glgroup (
  glgroupid INT NOT NULL,
  glgrouptypeid INT NOT NULL,
  placeid INT NOT NULL,
  glgroupdate VARCHAR(96) NOT NULL,
  glgroupname VARCHAR(32) NOT NULL,
  glgroupcriteria VARCHAR(128) NOT NULL,
  PRIMARY KEY (glgroupid),
  FOREIGN KEY (GLGROUPTYPEID) REFERENCES glngdb.GLGROUPTYPE (GLGROUPTYPEID),
  FOREIGN KEY (PLACEID) REFERENCES glngdb.PLACE (PLACEID)
);

DROP TABLE glngdb.glgrouptyperole;

CREATE TABLE glngdb.glgrouptyperole (
  glgrouptyperoleid INT NOT NULL,
  glgrouptypeid INT NOT NULL,
  glgrouptypename VARCHAR(32) NOT NULL,
  sequencenumber INT NOT NULL,
  PRIMARY KEY (glgrouptyperoleid),
  FOREIGN KEY (GLGROUPTYPEID) REFERENCES glngdb.GLGROUPTYPE (GLGROUPTYPEID)
);

DROP TABLE glngdb.reposource;

-- The RSACTIVITYID FK in this table *should* refer to the SEARCH table rather
-- than the ACTIVITY table, but for some reason DERBY is failing to create the
-- link ...
CREATE TABLE glngdb.reposource (
  repo_sourceid INT NOT NULL,
  repositoryid INT NOT NULL,
  sourceid INT NOT NULL,
  rsactivityid INT NOT NULL,
  callnumber VARCHAR(32),
  description VARCHAR(128),
  PRIMARY KEY (repo_sourceid),
  FOREIGN KEY (REPOSITORYID) REFERENCES glngdb.REPOSITORY (REPOSITORYID),
  FOREIGN KEY (SOURCEID) REFERENCES glngdb.SOURCE (SOURCEID),
  FOREIGN KEY (RSACTIVITYID) REFERENCES glngdb.ACTIVITY (ACTIVITYID)
);
