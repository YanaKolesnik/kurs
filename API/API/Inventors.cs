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
    
    public partial class Inventors
    {
        public int ID { get; set; }
        public string Name_article { get; set; }
        public Nullable<float> Rating { get; set; }
        public Nullable<int> Count { get; set; }
    
        public virtual InventorsArticles InventorsArticles { get; set; }
    }
}
