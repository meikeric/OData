﻿using Microsoft.AspNet.OData;
using Microsoft.AspNet.OData.Query;
using Microsoft.OData.Edm;
using Microsoft.OData.UriParser;
using System;
using System.Collections.Generic;
using System.Data.Common;


namespace maskx.OData.Sql
{
    public static class Extensions
    {
        public static bool IsDBNull(this DbDataReader reader, string columnName)
        {
            return Convert.IsDBNull(reader[columnName]);
        }
        internal static string ParseSelect(this ODataQueryOptions options)
        {
            if (options.Count != null)
                return "count(0)";
            if (options.SelectExpand == null)
                return "*";
            if (options.SelectExpand.SelectExpandClause.AllSelected)
                return "*";
            List<string> s = new List<string>();
            PathSelectItem select = null;
            foreach (var item in options.SelectExpand.SelectExpandClause.SelectedItems)
            {
                select = item as PathSelectItem;
                if (select != null)
                {
                    foreach (PropertySegment path in select.SelectedPath)
                    {
                        s.Add(string.Format("[{0}]", path.Property.Name));
                    }
                }
            }
            return string.Join(",", s);
        }
        internal static string ParseSelect(this ExpandedNavigationSelectItem expanded)
        {
            if (expanded.CountOption.HasValue)
                return "count(0)";
            if (expanded.SelectAndExpand == null)
                return "*";
            if (expanded.SelectAndExpand.AllSelected)
                return "*";
            List<string> s = new List<string>();
            PathSelectItem select = null;
            foreach (var item in expanded.SelectAndExpand.SelectedItems)
            {
                select = item as PathSelectItem;
                if (select != null)
                {
                    foreach (PropertySegment path in select.SelectedPath)
                    {
                        s.Add(string.Format("[{0}]", path.Property.Name));
                    }
                }
            }
            return string.Join(",", s);
        }
        
        internal static void SetEntityPropertyValue(this DbDataReader reader, int fieldIndex, EdmStructuredObject entity)
        {
            string name = reader.GetName(fieldIndex);
            if (reader.IsDBNull(fieldIndex))
            {
                entity.TrySetPropertyValue(name, null);
                return;
            }
            if (reader.GetFieldType(fieldIndex) == typeof(DateTime))
            {
                entity.TrySetPropertyValue(name, new DateTimeOffset(reader.GetDateTime(fieldIndex)));
            }
            else
            {
                entity.TrySetPropertyValue(name, reader.GetValue(fieldIndex));
            }
        }
       
    }
}
