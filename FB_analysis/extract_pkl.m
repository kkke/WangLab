function data =  extract_pkl(filename, animalID, date, session, region)
    data = load(filename);
    data.animalID = animalID;
    data.date     = date;
    data.session  = session;
    data.region   = region;
