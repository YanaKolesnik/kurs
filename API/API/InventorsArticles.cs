//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BasicAuthentication
{
    using System;
    using System.Collections.Generic;
    
    public partial class InventorsArticles
    {
        public int ID_Article { get; set; }
        public string Name { get; set; }
        public string Link_Text { get; set; }
        public string Link_Image { get; set; }
    
        public virtual Inventors Inventors { get; set; }
    }
}
