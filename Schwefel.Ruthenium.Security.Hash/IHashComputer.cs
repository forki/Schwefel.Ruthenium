﻿using System.Text;

namespace Schwefel.Ruthenium.Security.Hash
{
    public interface IHashComputer
    {
        Encoding DefaultEncoding
        {
            get;
        }
        int MaxLenght
        {
            get;
        }
        bool RemoveSeperators
        {
            get;
        }

        string StartSalt
        {
            get;
        }

        string EndSalt
        {
            get;
        }

        string ComputeHash(string input);
    }
}