use crate::config::application::Application;
use crate::config::key::deserialize_key;
use crate::config::modmap_action::ModmapAction;
use evdev::Key;
use serde::{Deserialize, Deserializer};
use std::collections::HashMap;

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Modmap {
    #[serde(default = "String::new")]
    pub name: String,
    #[serde(deserialize_with = "deserialize_remap")]
    pub remap: HashMap<Key, ModmapAction>,
    pub application: Option<Application>,
}

fn deserialize_remap<'de, D>(deserializer: D) -> Result<HashMap<Key, ModmapAction>, D::Error>
where
    D: Deserializer<'de>,
{
    #[derive(Deserialize, Eq, Hash, PartialEq)]
    struct KeyWrapper(#[serde(deserialize_with = "deserialize_key")] Key);

    let v = HashMap::<KeyWrapper, ModmapAction>::deserialize(deserializer)?;
    Ok(v.into_iter().map(|(KeyWrapper(k), v)| (k, v)).collect())
}
