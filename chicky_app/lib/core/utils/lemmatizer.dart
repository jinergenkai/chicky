/// Simple rule-based English lemmatizer.
/// Handles the most common inflection patterns for English words.
/// Used to normalize user vocabulary lookups and scan tokenization.
String simpleLemmatize(String word) {
  final w = word.toLowerCase();

  // Irregular verbs
  const irregularVerbs = {
    'was': 'be',
    'were': 'be',
    'is': 'be',
    'are': 'be',
    'am': 'be',
    'been': 'be',
    'being': 'be',
    'had': 'have',
    'has': 'have',
    'having': 'have',
    'did': 'do',
    'does': 'do',
    'doing': 'do',
    'done': 'do',
    'went': 'go',
    'gone': 'go',
    'goes': 'go',
    'going': 'go',
    'said': 'say',
    'says': 'say',
    'saw': 'see',
    'seen': 'see',
    'sees': 'see',
    'took': 'take',
    'taken': 'take',
    'takes': 'take',
    'came': 'come',
    'comes': 'come',
    'known': 'know',
    'knew': 'know',
    'knows': 'know',
    'got': 'get',
    'gotten': 'get',
    'gets': 'get',
    'made': 'make',
    'makes': 'make',
    'thought': 'think',
    'thinks': 'think',
    'told': 'tell',
    'tells': 'tell',
    'found': 'find',
    'finds': 'find',
    'gave': 'give',
    'given': 'give',
    'gives': 'give',
    'felt': 'feel',
    'feels': 'feel',
    'left': 'leave',
    'leaves': 'leave',
    'brought': 'bring',
    'brings': 'bring',
    'kept': 'keep',
    'keeps': 'keep',
    'began': 'begin',
    'begun': 'begin',
    'begins': 'begin',
    'ran': 'run',
    'runs': 'run',
    'running': 'run',
    'sat': 'sit',
    'sits': 'sit',
    'stood': 'stand',
    'stands': 'stand',
    'lost': 'lose',
    'loses': 'lose',
    'led': 'lead',
    'leads': 'lead',
    'read': 'read',
    'reads': 'read',
    'held': 'hold',
    'holds': 'hold',
    'meant': 'mean',
    'means': 'mean',
    'set': 'set',
    'sets': 'set',
    'met': 'meet',
    'meets': 'meet',
    'paid': 'pay',
    'pays': 'pay',
    'heard': 'hear',
    'hears': 'hear',
    'let': 'let',
    'lets': 'let',
    'put': 'put',
    'puts': 'put',
    'wrote': 'write',
    'written': 'write',
    'writes': 'write',
    'grew': 'grow',
    'grown': 'grow',
    'grows': 'grow',
    'drew': 'draw',
    'drawn': 'draw',
    'draws': 'draw',
    'flew': 'fly',
    'flown': 'fly',
    'flies': 'fly',
    'threw': 'throw',
    'thrown': 'throw',
    'throws': 'throw',
    'bought': 'buy',
    'buys': 'buy',
    'caught': 'catch',
    'catches': 'catch',
    'taught': 'teach',
    'teaches': 'teach',
    'fought': 'fight',
    'fights': 'fight',
    'sought': 'seek',
    'seeks': 'seek',
    'built': 'build',
    'builds': 'build',
    'sent': 'send',
    'sends': 'send',
    'spent': 'spend',
    'spends': 'spend',
    'lent': 'lend',
    'lends': 'lend',
    'bent': 'bend',
    'bends': 'bend',
    'dealt': 'deal',
    'deals': 'deal',
    'slept': 'sleep',
    'sleeps': 'sleep',
    'woke': 'wake',
    'woken': 'wake',
    'wakes': 'wake',
    'wore': 'wear',
    'worn': 'wear',
    'wears': 'wear',
    'broke': 'break',
    'broken': 'break',
    'breaks': 'break',
    'chose': 'choose',
    'chosen': 'choose',
    'chooses': 'choose',
    'spoke': 'speak',
    'spoken': 'speak',
    'speaks': 'speak',
    'stole': 'steal',
    'stolen': 'steal',
    'steals': 'steal',
    'froze': 'freeze',
    'frozen': 'freeze',
    'freezes': 'freeze',
    'rode': 'ride',
    'ridden': 'ride',
    'rides': 'ride',
    'rose': 'rise',
    'risen': 'rise',
    'rises': 'rise',
    'drove': 'drive',
    'driven': 'drive',
    'drives': 'drive',
  };

  if (irregularVerbs.containsKey(w)) {
    return irregularVerbs[w]!;
  }

  // Irregular plurals
  const irregularPlurals = {
    'children': 'child',
    'men': 'man',
    'women': 'woman',
    'teeth': 'tooth',
    'feet': 'foot',
    'mice': 'mouse',
    'geese': 'goose',
    'oxen': 'ox',
    'cacti': 'cactus',
    'fungi': 'fungus',
    'alumni': 'alumnus',
    'syllabi': 'syllabus',
    'nuclei': 'nucleus',
    'radii': 'radius',
    'stimuli': 'stimulus',
    'people': 'person',
    'dice': 'die',
    'criteria': 'criterion',
    'phenomena': 'phenomenon',
    'data': 'datum',
    'media': 'medium',
    'indices': 'index',
    'matrices': 'matrix',
    'vertices': 'vertex',
    'appendices': 'appendix',
  };

  if (irregularPlurals.containsKey(w)) {
    return irregularPlurals[w]!;
  }

  // -ing forms (gerund/present participle)
  if (w.endsWith('ing') && w.length > 5) {
    // double consonant: running -> run
    if (w.length > 6) {
      final stem = w.substring(0, w.length - 3);
      if (stem.length >= 3 &&
          stem[stem.length - 1] == stem[stem.length - 2] &&
          'aeiou'.contains(stem[stem.length - 3])) {
        return stem.substring(0, stem.length - 1);
      }
    }
    // silent e: making -> make
    final stemE = w.substring(0, w.length - 3);
    if (stemE.length >= 2 && !'aeiou'.contains(stemE[stemE.length - 1])) {
      return '${stemE}e';
    }
    // regular: playing -> play
    return w.substring(0, w.length - 3);
  }

  // -ed forms (past tense / past participle)
  if (w.endsWith('ed') && w.length > 4) {
    // double consonant: stopped -> stop
    final stemDbl = w.substring(0, w.length - 2);
    if (stemDbl.length >= 3 &&
        stemDbl[stemDbl.length - 1] == stemDbl[stemDbl.length - 2] &&
        'aeiou'.contains(stemDbl[stemDbl.length - 3])) {
      return stemDbl.substring(0, stemDbl.length - 1);
    }
    // -ied -> -y: studied -> study
    if (w.endsWith('ied')) {
      return '${w.substring(0, w.length - 3)}y';
    }
    // silent e: liked -> like
    final stemE = w.substring(0, w.length - 1);
    if (stemE.length >= 2 && !'aeiou'.contains(stemE[stemE.length - 1])) {
      return stemE;
    }
    // regular: played -> play
    return w.substring(0, w.length - 2);
  }

  // -s / -es (third person singular or plural)
  if (w.endsWith('ies') && w.length > 4) {
    // studies -> study
    return '${w.substring(0, w.length - 3)}y';
  }
  if (w.endsWith('ses') || w.endsWith('xes') || w.endsWith('zes') ||
      w.endsWith('ches') || w.endsWith('shes')) {
    // boxes -> box, watches -> watch
    return w.substring(0, w.length - 2);
  }
  if (w.endsWith('s') && !w.endsWith('ss') && w.length > 3) {
    return w.substring(0, w.length - 1);
  }

  // -er comparative / agent noun  (simple heuristic)
  if (w.endsWith('er') && w.length > 4) {
    // runner -> run (double consonant)
    final stem = w.substring(0, w.length - 2);
    if (stem.length >= 3 &&
        stem[stem.length - 1] == stem[stem.length - 2] &&
        'aeiou'.contains(stem[stem.length - 3])) {
      return stem.substring(0, stem.length - 1);
    }
  }

  // -est superlative
  if (w.endsWith('est') && w.length > 5) {
    final stem = w.substring(0, w.length - 3);
    if (stem.length >= 3 &&
        stem[stem.length - 1] == stem[stem.length - 2] &&
        'aeiou'.contains(stem[stem.length - 3])) {
      return stem.substring(0, stem.length - 1);
    }
    return stem;
  }

  // -ly adverbs -> adjective
  if (w.endsWith('ly') && w.length > 4) {
    final stem = w.substring(0, w.length - 2);
    // happily -> happy
    if (stem.endsWith('il')) {
      return '${stem.substring(0, stem.length - 2)}y';
    }
    return stem;
  }

  return w;
}
