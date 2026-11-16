use kernel::prelude::*;

module! {
    type: Lapoisse,
    name: "lapoisse",
    authors: ["Badr @pythops"],
    description: "Lapoisse Module",
    license: "GPL",
}

struct Lapoisse;

impl kernel::Module for Lapoisse {
    fn init(_module: &'static ThisModule) -> Result<Self> {
        pr_info!("***** Caporal Lapoisse au rapport ! *****");
        Ok(Lapoisse)
    }
}

impl Drop for Lapoisse {
    fn drop(&mut self) {
        pr_info!("***** Adieu, mon Kernel ! *****\n");
    }
}
